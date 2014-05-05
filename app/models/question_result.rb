class QuestionResult < ActiveRecord::Base
  attr_accessible :question_id, :result, :user_id, :tag_id, :level
  scope :false_result, lambda { |uid, tagid|
    where(user_id: uid, tag_id: tagid, result: "false")
  }
  scope :correct_result, lambda { |uid, tagid|
    where(user_id: uid, tag_id: tagid, result: "true")
  }
  
  def self.correct_percentage(uid, tagid)
    false_records = false_result(uid, tagid).count
    correct_records = correct_result(uid, tagid).count
    100 * (correct_records / (false_records + correct_records))
  rescue
    0
  end

  def self.correct_percentage_by_level(uid, tagid, level)
    false_records = false_result(uid, tagid).where(level: level).count
    correct_records = correct_result(uid, tagid).where(level: level).count
    100 * (correct_records / (false_records + correct_records))
  rescue
    0
  end
end
