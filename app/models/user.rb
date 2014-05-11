class User < ActiveRecord::Base
  attr_accessible :name, :provider, :token, :uuid
  before_create :generate_token!
  after_create :set_default_degree

  has_many :degrees

  validates :provider, inclusion: { in: %w(facebook twitter) }
  validates_uniqueness_of :name, :uuid
  validates_presence_of :name, :uuid, :provider

  SCOREMAP = [
    {id: 1, degree: Degree::TYPE::BEGINNER, score: 0},
    {id: 2, degree: Degree::TYPE::INTERMEDIATE, score: 20},
    {id: 3, degree: Degree::TYPE::SENIOR, score: 30},
    {id: 4, degree: Degree::TYPE::MASTER, score: 60},
    {id: 5, degree: Degree::TYPE::LEGENDARY, score: 90}
  ]
  
  
  def degree_by_tag(tag_id)
    ratio_arr = []
    (1..Question::LEVELNUM).each do |lvl|
      ratio_arr << QuestionResult.correct_percentage_by_level(self.id, tag_id, lvl)
    end
    sc = score(ratio_arr) 
    found = SCOREMAP.find {|deg| deg[:score] <= sc}
    return found[:degree]
  rescue Exception => e
    logger.error("Degree by tag error, tag input: #{tag}, message: " + e.message)
    return "beginner"
  end
  
  def update_degree(tag_id)
    deg_content = degree_by_tag(tag_id)
    degree = Degree.find_by_tag_id_and_user_id(Tag.find(tag).id, self.id)
    degree.content = deg_content
    degree.save
    return degree
  rescue Exception => e
    logger.error("Update degree error: " + e.message)
    false
  end
  
  def score(ratio_arr)
    sum = 0
    ratio_arr.each_with_index do |idx, rat|
      sum += Question::LEVELWEIGHT[idx+1] * rat / 100
    end
    sum
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
end
