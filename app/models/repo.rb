 class Repo < ActiveRecord::Base
  include Labelable

  has_and_belongs_to_many :boards
  has_many :issues
  has_many :labels

  validates :name, presence: true
  validates :name, uniqueness: true

  def add_issues(issues_hash)
    issues_hash.each do |issue_data|
      parser = GithubUtils::IssueParser.new(issue_data)
      issue  = Issue.new(parser.parse)
      issue.update_label_info(self.id, issue_data[:labels])
      self.issues << issue
    end
  end
end
