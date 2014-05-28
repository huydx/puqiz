class Degree < ActiveRecord::Base
  self.inheritance_column = "type_inheritance"
  
  # point use for level-calulate purpose
  # accumulate_point use for user xp(ranking purpose)
  attr_accessible :tag_id, :type, :user_id, :point, :accumulate_point
  validates :type, inclusion: {in: (1..5)}
  before_save :clean_param!
  after_initialize :set_default_values
  
  scope :top, lambda { |tagid, _limit, _offset|
    where(tag_id: tagid)
    .order("accumulate_point desc")
    .limit(_limit)
    .offset(_offset)
  }

  module TYPE
    BEGINNER = 1
    INTERMEDIATE = 2
    SENIOR = 3
    MASTER = 4
    LEGENDARY = 5
    DEFAULT = BEGINNER
  end

  SCORETABLE = [
    {id: 1, degree: TYPE::BEGINNER, score: 100},
    {id: 2, degree: TYPE::INTERMEDIATE, score: 500},
    {id: 3, degree: TYPE::SENIOR, score: 1000},
    {id: 4, degree: TYPE::MASTER, score: 3000},
    {id: 5, degree: TYPE::LEGENDARY, score: 5000}
  ]

  def update_new_degree
    new_deg_type = TYPE::LEGENDARY
    SCORETABLE.each do |degree_map|
      if self.point <= degree_map[:score]
        new_deg_type = degree_map[:degree] and break
      end
    end
    if new_deg_type != self.type
      self.type = new_deg_type 
      return true
    else
      return false
    end
  rescue Exception => e
    logger.error(e.backtrace.join("\n"))
    return false
  end

  def increment_point_by!(increment_point)
    self.point = self.point.to_i + increment_point.to_i
    self.accumulate_point = self.accumulate_point.to_i + increment_point.to_i
    self.point = 0 if update_new_degree #reset if new level is set
    save
  end

  protected
  def clean_param!
    self.type = (type.nil? || type == 0) ? TYPE::DEFAULT : type.to_i
    normalize_point!
  end

  def normalize_point!
    self.point = point.to_i < 0 ? 0 : point
    self.accumulate_point = accumulate_point.to_i < 0 ? 0 : accumulate_point
  end

  def set_default_values
    return unless new_record?
    self.point = 0
    self.accumulate_point = 0
    self.type = TYPE::DEFAULT
  end
end
