class CreateOperations < ActiveRecord::Migration
  def change
    create_table :operations do |t|
      t.integer :alarm_id, :null => false
      t.integer :operator_id, :null => false
      t.string :first_operand, :limit => 100
      t.string :second_operand, :limit => 100
      t.integer :position, :null => false

      t.timestamps
    end
  end
end
