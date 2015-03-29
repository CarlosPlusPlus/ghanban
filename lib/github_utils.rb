module GithubUtils
  module Client
    WEBHOOKS = ['issues', 'issue_comment']

    def add_webhooks(repo)
      WEBHOOKS.each { |wh| client.subscribe(
        "https://github.com/#{repo.name}/events/#{wh}.json",
        callback_url, ENV['GITHUB_WEBHOOK_SECRET']) }
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
    OPS_ATTRS  = {
      assignee:  { avatar: :avatar_url, gh_id: :id, gh_login: :login },
      milestone: { id: :id, title: :title, url: :html_url      }
    }

    def initialize(issue)
      @issue = issue
    end

    def parse
      attrs = parse_base_attrs
      attrs.merge(parse_github_attrs)
      attrs.merge(parse_optional_attrs)
    end

    private
      def parse_base_attrs
        {}.tap { |h| ROOT_ATTRS.each { |attr| h[attr] = issue[attr] } }
      end

      def parse_github_attrs
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

      def parse_optional_attrs
        {}.tap { |h| OPS_ATTRS.each do |attr, fields|
            if base = issue[attr]
              fields.each { |k,v| h["#{attr}_#{k}".to_sym] = base[v] }
            end
          end
        }
      end
  end
end
