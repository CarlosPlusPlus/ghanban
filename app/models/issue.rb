class Issue < ActiveRecord::Base
  include Labelable

  has_and_belongs_to_many :labels
  belongs_to :repo

  self.inheritance_column = nil

  ISSUE_CATEGORIES = ['category', 'priority', 'status', 'size', 'team', 'type']

  def add_custom_attributes(labels)
    labels.each do |label|
      type, value = label[:name].split(':')
      self[type.to_sym] = value.strip if ISSUE_CATEGORIES.include?(type)
    end
  end

  def clear_custom_attributes
    ISSUE_CATEGORIES.each { |category| self[category.to_sym] = nil }
  end
end
