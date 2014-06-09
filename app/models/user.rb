class User < ActiveRecord::Base
  attr_accessible :name, :provider, :token, :uuid, :avatar, :persistence_token
  before_create :generate_token
  after_create :set_default_degree
  before_update :generate_token

  has_many :degrees

  validates :provider, inclusion: { in: %w(facebook twitter) }
  validates_uniqueness_of :name, :uuid
  validates_presence_of :name, :uuid, :provider

  acts_as_authentic do |c|
    c.validate_email_field = false
    c.validate_password_field = false
  end

  scope :sort_with_array, lambda { |ids| 
    where(id: ids)
    .order("field(id, #{ids.join(',')})")
  }

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless User.exists?(token: random_token)
    end
  end

  def self.find_for_twitter_oauth(auth_hash)
    name = auth_hash["info"]["nickname"]
    user = self.find_for_oauth(auth_hash) 
    return nil unless
      user && user.name == name && user.provider == "twitter"
    return user
  end

  def self.find_for_facebook_oauth(auth_hash)
    user = self.find_for_oauth(auth_hash) 
    return nil unless user && user.provider == "facebook"
    return user
  end

  def self.find_for_oauth(auth_hash)
    uid = auth_hash["uid"]
    user = User.find_by_uuid(uid)
  rescue Exception => e
    logger.error(e.message)
    return nil
  end

  protected
  def set_default_degree
    Tag.all.each do |tag|
      Degree.create(user_id: self.id, tag_id: tag.id, type: Degree::TYPE::BEGINNER)
    end
  end
end
