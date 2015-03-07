module GithubUtils
  def get_labels(repo_name)
    client.labels(repo_name)
  end

  def get_issues(repo_name)
    client.auto_paginate = true # Access to ALL issues.
    client.issues(repo_name, state: 'all')
  end

  def get_repos
    client.repos
  end

  private
    def client
      @client ||= Octokit::Client.new(access_token: session[:access_token])
    end
end
