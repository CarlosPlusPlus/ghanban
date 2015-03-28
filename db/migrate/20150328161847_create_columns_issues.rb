class CreateColumnsIssues < ActiveRecord::Migration
  def change
    create_table :columns_issues do |t|
      t.belongs_to :column, index: true
      t.belongs_to :issue,  index: true
    end
  end
end
