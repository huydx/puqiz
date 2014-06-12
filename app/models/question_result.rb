class QuestionResult < ActiveRecord::Base
  attr_accessible :question_id, :result, :user_id, :tag_id, :level, :try_time
  validates :result, inclusion: {in: ["true", "false"]}

  scope :false_result, lambda { |uid, tagid|
    where(user_id: uid, tag_id: tagid, result: "false")
  }
  scope :correct_result, lambda { |uid, tagid|
    where(user_id: uid, tag_id: tagid, result: "true")
  }
  
  def self.correct_percentage(uid, tagid)
    false_records = false_result(uid, tagid).count.to_f
    correct_records = correct_result(uid, tagid).count.to_f
    ret = 100 * (correct_records / (false_records + correct_records))
    ret = ret.nan? ? 0 : ret.round(3)
  rescue
    0
  end

  def self.correct_percentage_by_level(uid, tagid, level)
    false_records = false_result(uid, tagid).where(level: level).count.to_f
    correct_records = correct_result(uid, tagid).where(level: level).count.to_f
    100 * (correct_records / (false_records + correct_records))
    ret = ret.nan? ? 0 : ret.round(3)
  rescue
    0
  end
end
