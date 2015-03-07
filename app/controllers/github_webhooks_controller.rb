class GithubWebhooksController < ActionController::Base
  include GithubWebhook::Processor

  def issues(payload)
    puts 'I made it into the issue webhook action!'
  end

  def issue_comment(payload)
    puts 'I made it into the issue_comment webhook action!'
  end

  def webhook_secret(payload)
  end
end
