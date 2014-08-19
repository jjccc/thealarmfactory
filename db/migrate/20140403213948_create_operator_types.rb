class CreateOperatorTypes < ActiveRecord::Migration
  def change
    create_table :operator_types do |t|
      t.string :name, :null => false, :limit => 100

      t.timestamps
    end
  end
end
