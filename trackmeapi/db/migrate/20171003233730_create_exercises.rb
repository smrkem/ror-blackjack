class CreateExercises < ActiveRecord::Migration[5.1]
  def change
    create_table :exercises do |t|
      t.datetime :performed_at
      t.integer :duration_minutes
      t.integer :avg_heart_rate
      t.string :created_by

      t.timestamps
    end
  end
end
