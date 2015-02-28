class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.string :name
      t.integer :repo_id
      t.timestamps null: false
    end
  end
end
