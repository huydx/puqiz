class Tag < ActiveRecord::Base
  attr_accessible :content, :image, :explaination, :explaination_url
  validates_uniqueness_of :content
  after_save :generate_explaination_url

  DEFAULT_TAG = 1

  mount_uploader :image, TagImageUploader

  def self.updated_after(time)
    result = []
    Tag.all.each { |t| result << t if time < t.updated_at }
    return result
  end

  def generate_explaination_url
    host = case Rails.env
           when "production"; "http://puqiz.com";
           when "development"; "http://localhost:3000"
           end
    unless self.explaination_url
      explaination_url = 
        host + "/api/tags/#{self.id.to_s}/explaination"
      self.update_attribute(:explaination_url, explaination_url)
    end

    r = RecentlyUpdateTag.find_or_create_by_tag_id(self.id)
    r.touch
  end
end
