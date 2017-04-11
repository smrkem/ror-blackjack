class CreateHealthStatuses < ActiveRecord::Migration[5.0]
  def change
    create_table :health_statuses do |t|
      t.integer :mindfulness
      t.integer :physically_active
      t.integer :happiness
      t.integer :diet
      t.integer :mentally_active
      t.integer :socially_active

      t.timestamps
    end
  end
end
