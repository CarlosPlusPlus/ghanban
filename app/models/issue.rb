class Issue < ActiveRecord::Base
  # [TODO] CJL // 2015-03-12
  # Worth moving the label methods into a concern?
  # Is Lableable something multiple classes want?
  # => Look @ issue.rb && github_utils.rb

  include GithubUtils::Parser

  ISSUE_CATEGORIES = ['category', 'priority', 'status', 'size', 'team', 'type']

  has_and_belongs_to_many :labels
  belongs_to :repo

  def update_label_info(repo_id, labels)
    if labels.present?
      self.add_labels(repo_id, labels)
      self.add_custom_attributes(labels)
    end
  end

  def add_custom_attributes(labels)
    labels.each do |label|
      type, value = label[:name].split(':')
      # [TODO] CJL // 2015-03-12
      # Remigrate type column per the following link:
      # ==> http://stackoverflow.com/questions/7134559/rails-use-type-column-without-sti
      type = 'issue_type' if type == 'type'
      self[type.to_sym] = value.strip if ISSUE_CATEGORIES.include?(type)
    end
  end

  def clear_labels
    self.labels.clear
  end

  def clear_custom_attributes(issue)
    ISSUE_CATEGORIES.each do |custom_category|
      custom_category = 'issue_type' if custom_category == 'type'
      custom_categories = {}
      custom_categories[custom_category.to_sym] = nil
      issue.update_attributes(custom_categories)
    end
  end
end
