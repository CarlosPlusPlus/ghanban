module GithubUtils
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

    # Access to Octokit client to be used by other methods.
    def client
      @client ||= Octokit::Client.new(access_token: session[:access_token])
      @client.auto_paginate = true
      @client
    end
  end

  class IssueParser
    attr_reader :issue

    ROOT_ATTRS = [:body, :closed_at, :comments, :comments_url, :html_url,
                  :number, :state, :title, :url]

    def initialize(issue)
      @issue = issue
    end

    def parse
      attrs = parse_base_attrs
      attrs.merge(parse_assignee_attrs)  if issue[:assignee]
      attrs.merge(parse_milestone_attrs) if issue[:milestone]

      attrs
    end

    private

      def parse_base_attrs
        base = {}.tap { |h| ROOT_ATTRS.each { |attr| h[attr] = issue[attr] }}
        base.merge(parse_gh_attrs)
      end

      def parse_gh_attrs
        {
          github_id:         issue[:id],
          github_created_at: issue[:created_at],
          github_updated_at: issue[:updated_at],
          organization:      issue[:url].split('/')[4],
          repo_name:         issue[:url].split('/')[5],
          user_gh_id:        issue[:user][:id],
          user_gh_login:     issue[:user][:login]
        }
      end

      def parse_assignee_attrs
        assignee = issue[:assignee]

        {
          assignee_avatar:   assignee[:avatar_url],
          assignee_gh_id:    assignee[:id],
          assignee_gh_login: assignee[:login]
        }
      end

      def parse_milestone_attrs
        milestone = issue[:milestone]

        {
          milestone_id:    milestone[:id],
          milestone_title: milestone[:title],
          milestone_url:   milestone[:html_url]
        }
      end
  end
end
