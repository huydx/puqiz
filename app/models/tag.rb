class Tag < ActiveRecord::Base
  attr_accessible :content, :image, :explaination, :explaination_url
  validates_uniqueness_of :content
  before_save :touch_recently_update_tag, :generate_explaination_url
  before_create :touch_recently_update_tag, :generate_explaination_url
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

  def generate_explaination_url
    self.explaination_url = 
      Rails.application.routes.url_helpers.explaination_api_tag_path(self)
  end
end
