class AddFeaturesToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :alarms_text, :string, :limit => 200
    add_column :plans, :samples_text, :string, :limit => 200
    add_column :plans, :support_text, :string, :limit => 200
    add_column :plans, :is_default, :boolean, :default => false, :null => false
  end
end
