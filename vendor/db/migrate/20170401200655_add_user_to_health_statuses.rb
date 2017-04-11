class AddUserToHealthStatuses < ActiveRecord::Migration[5.0]
  def change
    add_reference :health_statuses, :user, foreign_key: true
  end
end
