class AddPointToUser < ActiveRecord::Migration
  def change
    add_column :users, :point, :string
  end
end
