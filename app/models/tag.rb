class Tag < ActiveRecord::Base
  attr_accessible :content, :image, :explaination
  validates_uniqueness_of :content
  before_save :touch_recently_update_tag
  DEFAULT_TAG = 1

  mount_uploader :image, TagImageUploader

  def touch_recently_update_tag
    r = RecentlyUpdateTag.find_or_create_by(tag_id: self.id)
    r.touch
  end
end
