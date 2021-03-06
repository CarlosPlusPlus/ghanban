class Issue < ActiveRecord::Base
  include Labelable

  has_and_belongs_to_many :columns
  has_and_belongs_to_many :labels
  belongs_to :repo

  self.inheritance_column = nil

  ISSUE_CATEGORIES = ['category', 'priority', 'status', 'size', 'team', 'type']

  after_create :update_columns
  after_save   :update_columns

  def add_custom_attributes(labels)
    labels.each do |label|
      type, value = label[:name].split(':')
      self[type.to_sym] = value.strip if ISSUE_CATEGORIES.include?(type)
    end
  end

  def clear_custom_attributes
    ISSUE_CATEGORIES.each { |category| self[category.to_sym] = nil }
  end

  private
    def update_columns
      repo.boards.collect(&:columns).flatten.each(&:assign_column_issues)
    end
end
