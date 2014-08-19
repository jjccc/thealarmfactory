class AddOperandsToOperators < ActiveRecord::Migration
  def change
    add_column :operators, :operands, :integer, :null => false, :default => 1
  end
end
