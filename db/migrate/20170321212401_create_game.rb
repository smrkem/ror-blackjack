class CreateGame < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.json :game_data
      t.integer :bet, null: false
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps null: false
    end
  end
end
