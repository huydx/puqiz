class Tag < ActiveRecord::Base
  attr_accessible :content, :image, :explaination
  validates_uniqueness_of :content
  before_save :touch_recently_update_tag
  before_create :touch_recently_update_tag
  DEFAULT_TAG = 1

  mount_uploader :image, TagImageUploader

  def touch_recently_update_tag
    r = RecentlyUpdateTag.find_or_create_by_tag_id(self.id)
    r.touch
  end

  def self.updated_after(time)
    result = []
    Tag.all.each { |t| result << t if time < t.updated_at }
    return result
  end
end
