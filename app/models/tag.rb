class Tag < ActiveRecord::Base
  attr_accessible :content, :image, :explaination
  validates_uniqueness_of :content 
  DEFAULT_TAG = 1

  mount_uploader :image, TagImageUploader
end
