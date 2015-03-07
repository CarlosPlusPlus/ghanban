module GithubUtils
  # [TODO] CJL // 2015-03-07
  # Split modules into individual files

  module Client
    def get_labels(repo_name)
      client.labels(repo_name)
    end

    def get_issues(repo_name)
      client.issues(repo_name, state: 'all')
    end

    def get_repos
      client.repos
    end

    private
      def client
        @client ||= Octokit::Client.new(access_token: session[:access_token])
        @client.auto_paginate = true
        @client
      end
  end

  module Parser
    def parse_issue(issue)
      {
        :github_id         => issue[:id],
        :number            => issue[:number],
        :title             => issue[:title],
        :body              => issue[:body],
        :url               => issue[:url],
        :html_url          => issue[:html_url],
        :comments          => issue[:comments],
        :comments_url      => issue[:comments_url],
        :github_created_at => issue[:created_at],
        :github_updated_at => issue[:updated_at],
        :closed_at         => issue[:closed_at],
        :organization      => issue[:url].split('/')[4],
        :repo_name         => issue[:url].split('/')[5],
        :state             => issue[:state],
        :user_gh_id        => issue[:user][:id],
        :user_gh_login     => issue[:user][:login]
      }.merge(issue[:assignee] ? {
        :assignee_gh_id    => issue[:assignee][:id],
        :assignee_gh_login => issue[:assignee][:login],
        :assignee_avatar   => issue[:assignee][:avatar_url]
      } : {}).merge(issue[:milestone] ? {
        :milestone_id      => issue[:milestone][:id],
        :milestone_url     => issue[:milestone][:html_url],
        :milestone_title   => issue[:milestone][:title]
      } : {})
    end
  end
end
