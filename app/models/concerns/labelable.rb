module Labelable
  extend ActiveSupport::Concern

  def add_labels(repo_id, labels)
    labels.each do |label|
      self.labels << Label.find_or_create_by(
                            :repo_id => repo_id,
                            :name    => label[:name],
                            :url     => label[:url],
                            :color   => label[:color]
                          )
    end
  end

  def clear_labels
    self.labels.clear
  end

  def update_label_info(repo_id, labels)
    if labels.present?
      self.add_labels(repo_id, labels)
      self.add_custom_attributes(labels)
    end
  end
end
