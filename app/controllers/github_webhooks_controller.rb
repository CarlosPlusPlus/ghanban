class GithubWebhooksController < ActionController::Base
  include GithubWebhook::Processor
  include GithubUtils::Parser

  def issues(payload)
    puts 'I made it into the issue webhook action!'
    if issue = Issue.where(github_id: payload[:issue][:id]).first
      update_issue(issue, payload[:issue][:labels])
      issue.save
    else
      create_new_issue(payload)
    end
  end

  def issue_comment(payload)
    puts 'I made it into the issue_comment webhook action!'
  end

  def webhook_secret(payload)
    ENV['GITHUB_WEBHOOK_SECRET']
  end

  private
    def create_new_issue(payload)
      repo  = Repo.where(name: payload[:issue][:url].split('/')[4..5].join('/')).first
      repo.add_issues([payload[:issue]])
      repo.save
    end

    def update_issue(issue, labels)
      issue.clear_labels
      issue.clear_custom_attributes
      issue.update_label_info(issue.repo_id, labels)
      issue.add_custom_attributes(labels)
    end
end
