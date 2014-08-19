class AddOperatorTypeIdToOperators < ActiveRecord::Migration
  def change
    add_column :operators, :operator_type_id, :integer, :null => false, :default => 1
  end
end
