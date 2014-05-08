class Degree < ActiveRecord::Base
  attr_accessible :tag_id, :type, :user_id
  module TYPE
    BEGINNER = 1
    INTERMEDIATE = 2
    SENIOR = 3
    MASTER = 4
    LEGENDARY = 5
  end
end
