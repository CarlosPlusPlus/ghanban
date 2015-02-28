class Repo < ActiveRecord::Base
  has_and_belongs_to_many :boards
  has_many :issues

  validates :name, presence: true
  validates :name, uniqueness: true

  def add_issues(issues_hash)
    issues_hash.each { |issue| self.issues << Issue.new(name: issue[:title]) }
  end
end
