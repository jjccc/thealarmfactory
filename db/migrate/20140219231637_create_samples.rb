class CreateSamples < ActiveRecord::Migration
  def change
    create_table :samples do |t|
      t.float :value, :null => false
      t.integer :alarm_id, :null => false

      t.timestamps
    end
  end
end
