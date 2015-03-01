class Repo < ActiveRecord::Base
  has_and_belongs_to_many :boards
  has_many :issues

  validates :name, presence: true
  validates :name, uniqueness: true

  def add_issues(issues_hash)
    issues_hash.each { |issue| self.issues << Issue.new(parse_issue(issue)) }
  end

  def parse_issue(issue)
    issue_hash = {}
    
    issue_hash[:github_id] = issue[:id] 
    issue_hash[:number] = issue[:number]
    issue_hash[:title] = issue[:title]
    issue_hash[:body] = issue[:body] unless issue[:body] == ""
    issue_hash[:url] = issue[:url]
    issue_hash[:html_url] = issue[:html_url]
    issue_hash[:comments] = issue[:comments] unless issue[:comments] == 0
    issue_hash[:comments_url] = issue[:comments_url]
    issue_hash[:github_created_at] = issue[:created_at]
    issue_hash[:github_updated_at] = issue[:updated_at]
    issue_hash[:closed_at] = issue[:closed_at]
    issue_hash[:organization] = issue[:url].split("/")[4]
    issue_hash[:repo_name] = issue[:url].split("/")[5]
    issue_hash[:state] = issue[:state]
    issue_hash[:user_gh_id] = issue[:user][:id]
    issue_hash[:user_gh_login] = issue[:user][:login]
    if issue[:assignee]
      issue_hash[:assignee_gh_id] = issue[:assignee][:id]
      issue_hash[:assignee_gh_login] = issue[:assignee][:login]
      issue_hash[:assignee_avatar] = issue[:assignee][:avatar_url]
    end
    if issue[:milestone]
      issue_hash[:milestone_id] = issue[:milestone][:id]
      issue_hash[:milestone_url] = issue[:milestone][:html_url]
      issue_hash[:milestone_title] = issue[:milestone][:title]
    end

    #TODO Add Label Logid, including custom label attributes below
    # issue_hash[:category]
    # issue_hash[:priority]
    # issue_hash[:status]
    # issue_hash[:team]
    # issue_hash[:type]
    # issue_hash[:size] 

    return issue_hash
    
  end
end