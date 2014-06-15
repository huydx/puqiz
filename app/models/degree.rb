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
    {id: 1, degree: TYPE::BEGINNER, reaching_point: 100},
    {id: 2, degree: TYPE::INTERMEDIATE, reaching_point: 500},
    {id: 3, degree: TYPE::SENIOR, reaching_point: 1000},
    {id: 4, degree: TYPE::MASTER, reaching_point: 3000},
    {id: 5, degree: TYPE::LEGENDARY, reaching_point: 5000}
  ]

  def update_new_degree!
    return false if self.point > 0 && self.type == TYPE::LEGENDARY
    return false if self.point < 0 && self.type == TYPE::BEGINNER

    if self.point >= next_degree_reach_point
      self.type += 1
      self.point = 0
      return true
    end

    if self.point < 0
      self.type -= 1
      self.point = next_degree_reach_point + self.point
      return true
    end
    
    return false
  rescue Exception => e
    logger.error(e.backtrace.join("\n"))
    return false
  end

  def increment_point_by!(increment_point)
    self.point = self.point.to_i + increment_point.to_i
    self.accumulate_point = self.accumulate_point.to_i + increment_point.to_i
    update_new_degree! #reset if new level is set
    save
  end
  
  def point_until_next_level
    return 0 if self.type == TYPE::LEGENDARY        
    return next_degree_reach_point - self.point
  rescue Exception => e
    logger.error(e.backtrace.join('\n'))
    return 0
  end

  def point_until_down_level
    return 0 if self.type == TYPE::BEGINNER 
    return self.point
  rescue Exception => e
    logger.error(e.backtrace.join('\n'))
    return 0
  end
    
  def rank
    @ranking ||= 
      Degree
        .where("tag_id = ?", self.tag_id)
        .where("accumulate_point > ?", self.accumulate_point)
        .count + 1
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

  def next_degree_reach_point
    return 0 if self.type == TYPE::LEGENDARY
    SCORETABLE.find{|s| s[:degree] == self.type+1}.fetch(:reaching_point)
  end

  def prev_degree_reach_point
    return 0 if self.type == TYPE::BEGINNER
    SCORETABLE.find{|s| s[:degree] == self.type-1}.fetch(:reaching_point)
  end
end
