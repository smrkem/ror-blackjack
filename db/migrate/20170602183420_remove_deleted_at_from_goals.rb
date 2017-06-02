class RemoveDeletedAtFromGoals < ActiveRecord::Migration[5.0]
  def up
    remove_column :goals, :deleted_at
  end

  def down
    add_column :goals, :deleted_at, :datetime
  end
end
