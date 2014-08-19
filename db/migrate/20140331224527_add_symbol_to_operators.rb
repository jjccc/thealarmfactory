class AddSymbolToOperators < ActiveRecord::Migration
  def change
    add_column :operators, :symbol, :string
  end
end