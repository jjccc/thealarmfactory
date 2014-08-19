class CreateOperators < ActiveRecord::Migration
  def change
    create_table :operators do |t|
      t.integer :id
      t.string :name, :limit => 255, :null => false

      t.timestamps
    end
  end
end
