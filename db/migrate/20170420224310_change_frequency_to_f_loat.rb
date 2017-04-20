class ChangeFrequencyToFLoat < ActiveRecord::Migration[5.0]
  def up
    change_column :goals, :frequency, :float
  end

  def down
    change_column :goals, :frequency, :integer
  end
end
