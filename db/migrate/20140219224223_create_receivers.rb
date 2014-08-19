class CreateReceivers < ActiveRecord::Migration
  def change
    create_table :receivers do |t|
      t.string :name, :limit => 255, :null => false
      t.integer :alarm_id, :null => false

      t.timestamps
    end
  end
end
