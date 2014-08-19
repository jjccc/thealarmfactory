class AddUserIdToAlarms < ActiveRecord::Migration
  def change
    add_column :alarms, :user_id, :integer, :null => false, :default => 0
  end
end
