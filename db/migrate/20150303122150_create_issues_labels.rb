class CreateIssuesLabels < ActiveRecord::Migration
  def change
    create_table :issues_labels do |t|
      t.belongs_to :issue, index: true
      t.belongs_to :label,  index: true
    end
  end
end
