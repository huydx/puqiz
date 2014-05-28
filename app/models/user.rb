class User < ActiveRecord::Base
  attr_accessible :name, :provider, :token, :uuid
  before_create :generate_token!
  after_create :set_default_degree

  has_many :degrees

  validates :provider, inclusion: { in: %w(facebook twitter) }
  validates_uniqueness_of :name, :uuid
  validates_presence_of :name, :uuid, :provider

  def generate_token!
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless User.exists?(token: random_token)
    end
  end


  protected
  def set_default_degree
    Tag.all.each do |tag|
      Degree.create(user_id: self.id, tag_id: tag.id, type: Degree::TYPE::BEGINNER)
    end
  end
end
