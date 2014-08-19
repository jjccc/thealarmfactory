class DropBlocks < ActiveRecord::Migration
  def up
    drop_table :blocks
  end

  def down
  end
end
