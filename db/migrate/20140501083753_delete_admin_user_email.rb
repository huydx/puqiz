class DeleteAdminUserEmail < ActiveRecord::Migration
  def up
    remove_column :admin_users, :email 
  end

  def down
    add_column :admin_users, :email
  end
end
