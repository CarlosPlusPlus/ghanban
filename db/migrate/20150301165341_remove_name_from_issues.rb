class RemoveNameFromIssues < ActiveRecord::Migration
  def change
    remove_column :issues, :name, :string
  end
end
