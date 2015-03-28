class CreateColumns < ActiveRecord::Migration
  def change
    create_table :columns do |t|
      t.integer :board_id
      t.string :label_name

      t.timestamps null: false
    end
  end
end
