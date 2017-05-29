class AddDeletedAtToGoals < ActiveRecord::Migration[5.0]
  def change
    add_column :goals, :deleted_at, :datetime
  end
end
