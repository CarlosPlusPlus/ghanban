 class Repo < ActiveRecord::Base
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

  # [TODO] AJW // 2015-03-10
  # Add Label Logid, including custom label attributes below:
  #   issue_hash[:category]
  #   issue_hash[:priority]
  #   issue_hash[:status]
  #   issue_hash[:team]
  #   issue_hash[:type]
  #   issue_hash[:size]

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
