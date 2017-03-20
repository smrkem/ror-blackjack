class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.integer :balance, null: false
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps null: false
    end
  end
end
