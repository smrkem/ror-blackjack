class CreateGoalActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :goal_activities do |t|
      t.datetime :performed_at
      t.references :goal, foreign_key: true

      t.timestamps
    end
  end
end
