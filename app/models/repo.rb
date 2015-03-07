 class Repo < ActiveRecord::Base
  include GithubUtils::Parser

  has_and_belongs_to_many :boards
  has_many :issues
  has_many :labels

  validates :name, presence: true
  validates :name, uniqueness: true

  def add_issues(issues_hash)
    issues_hash.each do |issue|
      i = Issue.new(parse_issue(issue))
      i.add_labels(issue, self)
      self.issues << i
    end
  end

  # [TODO] CJL // 2015-03-04
  # DRY out this code and the one in issue.rb.
  def add_repo_labels(labels)
    labels.each do |label|
      self.labels << Label.find_or_create_by(
                       :repo_id => self.id,
                       :name    => label[:name],
                       :url     => label[:url],
                       :color   => label[:color]
                     )
    end
  end
end
