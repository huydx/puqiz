class CreateAdminUsers < ActiveRecord::Migration
  def change
    create_table :admin_users do |t|
      t.string :username
      t.string :crypted_password
      t.string :email
      t.string :password_salt
      t.string :persistence_token

      t.timestamps
    end
  end
end
