class Tag < ActiveRecord::Base
  attr_accessible :content
  validates_uniqueness_of :content 
end
