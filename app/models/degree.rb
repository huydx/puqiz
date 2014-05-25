class Degree < ActiveRecord::Base
  self.inheritance_column = "type_inheritance"

  attr_accessible :tag_id, :type, :user_id
  validates :type, inclusion: {in: (1..5)}
  before_save :clean_param

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

  def self.update_for_user!(user_instance)
    point = user_instance.point
    new_deg_type = TYPE::LEGENDARY
    SCORETABLE.each do |degree_map|
      if point <= degree_map[:score]
        new_deg_type = degree_map[:degree] and break
      end
    end
    current_deg = Degree.find_by_user_id(user_instance.id)
    return current_deg.type if current_deg.type == new_deg_type
    current_deg.update_attribute(:type, new_deg_type)
    current_deg.save
    return new_deg_type
  rescue Exception => e
    logger.error(e.backtrace)
  end

  protected
  def clean_param
    self.type = (type.nil? || type == 0) ? TYPE::DEFAULT : type.to_i
  end
end
