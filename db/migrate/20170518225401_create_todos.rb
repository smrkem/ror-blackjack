class CreateTodos < ActiveRecord::Migration[5.0]
  def change
    create_table :todos do |t|
      t.integer :parent_id
      t.string :name
      t.text :description
      t.datetime :due_date
      t.datetime :completed_date
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
