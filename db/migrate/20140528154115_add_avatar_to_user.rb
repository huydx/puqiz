class AddAvatarToUser < ActiveRecord::Migration
  def change
    add_column :users, :avatar, :string, limit: 1000
  end
end
