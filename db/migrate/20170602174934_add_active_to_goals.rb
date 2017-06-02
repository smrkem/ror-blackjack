class AddActiveToGoals < ActiveRecord::Migration[5.0]
  def change
    add_column :goals, :active, :boolean, default: true
  end
end
