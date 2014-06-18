class UserReport < ActiveRecord::Base
  attr_accessible :content, :provider, :question_id, :username
  paginates_per 40
end
