class Issue < ActiveRecord::Base
  has_and_belongs_to_many :labels
  belongs_to :repo

  ISSUE_CATEGORIES = ['category', 'priority', 'status', 'size', 'team', 'type']

  def add_labels(issue, repo)
    if labels = issue[:labels]
      repo_id = repo.id

      labels.each do |label|
        add_custom_attribute(label)
        self.labels << Label.find_or_create_by(
                         :repo_id => repo_id,
                         :name    => label[:name],
                         :url     => label[:url],
                         :color   => label[:color]
                       )
      end
    end
  end

  private
    def add_custom_attribute(label)
      label_type = label[:name].split(':').first
        if ISSUE_CATEGORIES.include?(label_type)
          label_type = 'issue_type' if label_type == 'type'
          # [TODO] CJL // 2015-03-07
          # Find a way to set attribute not using this notation.
          self[label_type.to_sym] = label[:name].split(":").last.strip
        end
    end

end
