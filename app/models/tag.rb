class Tag < ActiveRecord::Base
  attr_accessible :content
  validates_uniqueness_of :content 
  DEFAULT_TAG = "Ruby"
end
