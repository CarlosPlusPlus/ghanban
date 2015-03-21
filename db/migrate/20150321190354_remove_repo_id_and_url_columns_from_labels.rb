class RemoveRepoIdAndUrlColumnsFromLabels < ActiveRecord::Migration
  def change
    remove_column :labels, :repo_id, :integer
    remove_column :url, :url, :string
  end
end
