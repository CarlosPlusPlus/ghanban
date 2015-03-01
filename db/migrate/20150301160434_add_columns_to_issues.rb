class AddColumnsToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :github_id, :integer
    add_column :issues, :number, :integer
    add_column :issues, :title, :string
    add_column :issues, :body, :text
    add_column :issues, :url, :string
    add_column :issues, :html_url, :string
    add_column :issues, :comments, :integer
    add_column :issues, :comments_url, :string
    add_column :issues, :github_created_at, :datetime
    add_column :issues, :github_updated_at, :datetime
    add_column :issues, :closed_at, :datetime
    add_column :issues, :organization, :string
    add_column :issues, :repo, :string
    add_column :issues, :state, :string
    add_column :issues, :user_gh_id, :integer
    add_column :issues, :user_gh_login, :string
    add_column :issues, :assignee_gh_id, :integer
    add_column :issues, :assignee_gh_login, :string
    add_column :issues, :assignee_avatar, :string
    add_column :issues, :milestone_id, :integer
    add_column :issues, :milestone_url, :string
    add_column :issues, :milestone_title, :string
    add_column :issues, :category, :string
    add_column :issues, :priority, :string
    add_column :issues, :status, :string
    add_column :issues, :team, :string
    add_column :issues, :type, :string
    add_column :issues, :size, :int
  end
end
