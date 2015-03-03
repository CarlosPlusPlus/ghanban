class Issue < ActiveRecord::Base
  has_and_belongs_to_many :labels
  belongs_to :repo

  def add_labels(issue)
    if issue[:labels]
      repo_id = self.repo_id
      issue[:labels].each do |label|
        l = Label.find_or_create_by(
          repo_id: repo_id, 
          name: label[:name], 
          url: label[:url], 
          color: label[:color]
        )
      self.labels << l
      end
    end
  end
end
