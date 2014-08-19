class AddConditionToAlarms < ActiveRecord::Migration
  def change
    add_column :alarms, :condition, :string, :limit => 1000
  end
end
