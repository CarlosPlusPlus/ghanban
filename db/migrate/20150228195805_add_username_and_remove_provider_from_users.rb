class AddUsernameAndRemoveProviderFromUsers < ActiveRecord::Migration
  def change
    add_column    :users, :username, :string
    remove_column :users, :provider, :string
  end
end
