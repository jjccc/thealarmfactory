class AddApiTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :api_token, :string, :null => false, :default => "0"
  end
end
