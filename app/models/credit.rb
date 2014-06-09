class Credit < ActiveRecord::Base
  attr_accessible :username, :provider, :email, :question_number
end
