class CreateAlarms < ActiveRecord::Migration
  def change
    create_table :alarms do |t|
      t.integer :id
      t.string :name

      t.timestamps
    end
  end
end
