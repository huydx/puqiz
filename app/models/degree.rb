class Degree < ActiveRecord::Base
  self.inheritance_column = "type_inheritance"

  attr_accessible :tag_id, :type, :user_id, :point
  validates :type, inclusion: {in: (1..5)}
  before_save :clean_param!
  after_initialize :set_default_values

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

    self.type = new_deg_type if new_deg_type != self.type
  rescue Exception => e
    logger.error(e.backtrace.join("\n"))
  end

  def increment_point_by!(increment_point)
    self.point = self.point.to_i + increment_point.to_i
    update_new_degree
    save
  end

  protected
  def clean_param!
    self.type = (type.nil? || type == 0) ? TYPE::DEFAULT : type.to_i
    normalize_point!
  end

  def normalize_point!
    self.point = point.to_i < 0 ? 0 : point
  end

  def set_default_values
    return unless new_record?
    self.point = 0
  end
end
