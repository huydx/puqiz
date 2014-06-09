class UserReport < ActiveRecord::Base
  attr_accessible :content, :provider, :question_id, :username
end
