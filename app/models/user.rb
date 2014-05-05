class User < ActiveRecord::Base
  attr_accessible :name, :provider, :token, :uuid
  before_create :generate_token

  validates :provider, inclusion: { in: %w(facebook twitter) }
  validates_uniqueness_of :name, :uuid
  validates_presence_of :name, :uuid, :provider

  DEGREE = [
    {id: 1, name: "beginner", score: 0},
    {id: 2, name: "intermediate", score: 20},
    {id: 3, name: "senior", score: 30},
    {id: 4, name: "master", score: 60},
    {id: 5, name: "legendary", score: 90}
  ]
  
  RATIOWEIGHT = {1 => 5, 2 => 10, 3 => 20, 4 => 30, 5 => 45} #weigth for each level
  
  def degree_by_tag(tag)
    tag_id = Tag.find_by_content(tag).id
    ratio_arr = []
    (1..Question::LEVELNUM).each do |lvl|
      ratio_arr << QuestionResult.correct_percentage_by_level(self.id, tag_id, lvl)
    end
    sc = score(ratio_arr) 
    degree = DEGREE.find {|deg| deg[:score] <= sc}
    return degree
  rescue Exception => e
    logger.error("Invalid tag input: #{tag}, message: " + e.message)
  end

  def score(ratio_arr)
    sum = 0
    ratio_arr.each_with_index do |idx, rat|
      sum += RATIOWEIGHT[idx+1] * rat / 100
    end
    sum
  end

  protected
  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless User.exists?(token: random_token)
    end
  end
end
