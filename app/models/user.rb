class User < ActiveRecord::Base
  attr_accessible :name, :provider, :token, :uuid
  before_create :generate_token

  validates :provider, inclusion: { in: %w(facebook twitter) }
  validates_uniqueness_of :name, :uuid
  validates_presence_of :name, :uuid, :provider
  
  protected
  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless User.exists?(token: random_token)
    end
  end
end
