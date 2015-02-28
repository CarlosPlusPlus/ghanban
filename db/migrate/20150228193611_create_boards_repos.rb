class CreateBoardsRepos < ActiveRecord::Migration
  def change
    create_table :boards_repos do |t|
      t.belongs_to :board, index: true
      t.belongs_to :repo,  index: true
    end
  end
end
