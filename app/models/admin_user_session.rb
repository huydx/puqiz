class AdminUserSession < Authlogic::Session::Base
  authenticate_with AdminUser

  def to_key 
    new_record? ? nil : [ self.send(self.class.primary_key) ] 
  end 
end
