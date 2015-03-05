class Issue < ActiveRecord::Base
  has_and_belongs_to_many :labels
  belongs_to :repo

  def add_labels(issue, repo)
    if labels = issue[:labels]
      repo_id = repo.id

      labels.each do |label|
        self.labels << Label.find_or_create_by(
                         :repo_id => repo_id,
                         :name    => label[:name],
                         :url     => label[:url],
                         :color   => label[:color]
                       )
      end
    end
  end
end
