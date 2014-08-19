class AddFieldsToAlarms < ActiveRecord::Migration
  def change
    add_column :alarms, :samples_count, :integer, :null => false, :default => 0
    add_column :alarms, :has_notifications, :boolean, :null => false, :default => false
    add_column :alarms, :description, :string, :null => true, :limit => 600
  end
end