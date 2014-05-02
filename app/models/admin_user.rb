class AdminUser < ActiveRecord::Base
  attr_accessible :crypted_password, :password_salt, :persistence_token, :username, :password, :password_confirmation, :role

  acts_as_authentic do |c|
    c.login_field = 'username'
    c.session_class = AdminUserSession
  end

  def admin?
    role == "admin"
  end
end
