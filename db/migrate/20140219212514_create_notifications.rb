class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :alarm_id
      t.integer :sample_id

      t.timestamps
    end
  end
end
