module GithubUtils
  # [TODO] CJL // 2015-03-07
  # Split modules into individual files

  module Client
    WEBHOOKS = ['issues', 'issue_comment']

    def add_webhooks(repo)
      WEBHOOKS.each { |wh| client.subscribe "https://github.com/#{repo.name}/events/#{wh}.json", callback_url, ENV['GITHUB_WEBHOOK_SECRET'] }
    end

    def callback_url
      Rails.env.development? ? ENV['DEV_WEBHOOK_URL'] : ENV['PRD_WEBHOOK_URL']
    end

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

    ISSUE_CATEGORIES = ['category', 'priority', 'status', 'size', 'team', 'type']

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

    def update_issue(issue)
      i = Issue.find_or_create_by(github_id: issue[:id])
      parse_issue(issue)
      clear_labels(i)
      clear_custom_attributes(i)
      add_labels(issue[:labels], i) unless issue[:labels].length == 0
      i.save
    end

    def add_labels(labels, issue)
      labels.each do |label|
        add_custom_attribute(label, issue)
        issue.labels << Label.find_or_create_by(
                        :repo_id => issue.repo_id,
                        :name    => label[:name],
                        :url     => label[:url],
                        :color   => label[:color]
                       )
      end
    end

    def add_custom_attribute(label, issue)
      label_type = label[:name].split(':').first
      if ISSUE_CATEGORIES.include?(label_type)
        label_type = 'issue_type' if label_type == 'type'
        # [TODO] CJL // 2015-03-07
        # Find a way to set attribute not using this notation.
        issue[label_type.to_sym] = label[:name].split(":").last.strip
      end
    end

    def clear_labels(issue)
      issue.labels.clear
    end

    def clear_custom_attributes(issue)
      ISSUE_CATEGORIES.each do |custom_category|
        custom_category = 'issue_type' if custom_category == 'type'
        custom_categories = {}
        custom_categories[custom_category.to_sym] = nil
        issue.update_attributes(custom_categories)
      end
    end
  end
end
