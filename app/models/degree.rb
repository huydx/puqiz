class Degree < ActiveRecord::Base
  self.inheritance_column = "type_inheritance"

  attr_accessible :tag_id, :type, :user_id
  
  SCORETABLE = [
    {id: 1, degree: TYPE::BEGINNER, score: 100},
    {id: 2, degree: TYPE::INTERMEDIATE, score: 500},
    {id: 3, degree: TYPE::SENIOR, score: 1000},
    {id: 4, degree: TYPE::MASTER, score: 3000},
    {id: 5, degree: TYPE::LEGENDARY, score: 5000}
  ]

  module TYPE
    BEGINNER = 1
    INTERMEDIATE = 2
    SENIOR = 3
    MASTER = 4
    LEGENDARY = 5
  end

  protected
  def update_for_user!(user_instance)
    point = user_instance.point
    new_deg_type = nil
    SCORETABLE.each do |degree_map|
      if point >= degree_map[:score]
        new_deg_typ = degree_map[:degree] and break
      end
    end
    current_deg = Degree.find_by_user_id(uid)
    return current_deg if current_deg.type == new_deg_type
    current_deg.update_attribute(type: new_deg_type)
    return new_deg_type
  rescue
  end
end
