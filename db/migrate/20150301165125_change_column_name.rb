class ChangeColumnName < ActiveRecord::Migration
  def change
    rename_column :issues, :repo, :repo_name
  end
end
