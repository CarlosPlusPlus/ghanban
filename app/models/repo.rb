 class Repo < ActiveRecord::Base
  include GithubUtils::Parser

  has_and_belongs_to_many :boards
  has_many :issues
  has_many :labels

  validates :name, presence: true
  validates :name, uniqueness: true

  def add_issues(issues_hash)
    issues_hash.each do |issue_data|
      issue = Issue.new(parse_issue(issue_data))
      issue.update_label_info(self.id, issue_data[:labels])
      self.issues << issue
    end
  end
end
