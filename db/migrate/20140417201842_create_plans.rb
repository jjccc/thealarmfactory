class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name, :null => false, :limit => 100
      t.integer :position, :null => false
      t.float :price

      t.timestamps
    end
  end
end
