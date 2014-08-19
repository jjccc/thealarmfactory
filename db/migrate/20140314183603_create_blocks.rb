class CreateBlocks < ActiveRecord::Migration
  def change
    create_table :blocks do |t|
      t.integer :alarm_id, :null => false
      t.integer :operator_id, :null => false
      t.float :value
      t.integer :position, :null => false

      t.timestamps
    end
  end
end
