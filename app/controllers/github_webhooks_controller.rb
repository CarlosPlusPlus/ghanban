class GithubWebhooksController < ActionController::Base
  include GithubWebhook::Processor
  include GithubUtils::Parser

  def issues(payload)
    puts 'I made it into the issue webhook action!'
    # [TODO] CJL // 2015-03-12
    # Need to find_or_create_by: parse_issue(issue_data)
    # Make sure that if new Issue is added to right repo.
    issue = Issue.find_or_create_by(github_id: payload[:id])
    update_issue(issue, payload[:labels])
    issue.save
  end

  def issue_comment(payload)
    puts 'I made it into the issue_comment webhook action!'
  end

  def webhook_secret(payload)
    ENV['GITHUB_WEBHOOK_SECRET']
  end

  private
    def update_issue(issue, labels)
      issue.clear_labels
      issue.clear_custom_attributes
      issue.update_label_info(issue.repo.id, labels)
    end
end
