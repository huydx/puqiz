class User < ActiveRecord::Base
  attr_accessible :name, :provider, :token, :uuid, :point
  before_create :generate_token!, :normalize_point!
  after_create :set_default_degree

  has_many :degrees

  validates :provider, inclusion: { in: %w(facebook twitter) }
  validates_uniqueness_of :name, :uuid
  validates_presence_of :name, :uuid, :provider

  
  #def score(ratio_arr)
  #  sum = 0
  #  ratio_arr.each_with_index do |idx, rat|
  #    sum += Question::LEVELWEIGHT[idx+1] * rat / 100
  #  end
  #  sum
  #end
  
  def increment_point!(increment_point)
    self.point = self.point + increment_point.to_i
    save
  end

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

  def normalize_point!
    current_point = self.point.to_i
    self.point = current_point <= 0 ? 0 : current_point
  end
end
