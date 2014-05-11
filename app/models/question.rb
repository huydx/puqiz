class Question < ActiveRecord::Base
  attr_accessible :content, :tag_id, :level, :time, :answers_attributes
  has_many :answers, dependent: :destroy
  has_one :tag
  accepts_nested_attributes_for :answers, reject_if: lambda { |a| a[:content].blank? }

  #each user has their own degree for each tag,
  #for ex: beginner<-> ruby, intermediate <-> c++...
  #to know what degree user hold for a tag, we calculate score
  #by using correct percentage of question
  #However, question has its own level two, therefore
  #we define weight for each level of question, which mean that
  #the harder the question is, the more weight it has, the more score user accquire
  LEVELNUM = 5
  LEVELWEIGHT = {1 => 5, 2 => 10, 3 => 20, 4 => 30, 5 => 45}

  TIMERANGE = [2, 3, 5, 10, 15]
  ANSWERNUM = 4
  QUESTIONNUM_EACHREQUEST = 20
  
  scope :with_answers, lambda { includes(:answers) }
  scope :for_beginner, lambda { |_tag|
    where("tag_id = ? and level >= ? and level <= ?", _tag, 1, 2)
  }
  scope :for_intermediate, lambda { |_tag|
    where("tag_id = ? and level >= ? and level <= ?", _tag, 2, 3)
  }
  scope :for_senior, lambda { |_tag|
    where("tag_id = ? and level >= ? and level <= ?", _tag, 3, 4)
  }
  scope :for_master, lambda { |_tag|
    where("tag_id = ? and level >= ? and level <= ?", _tag, 4, 5)
  }
  scope :for_legendary, lambda { |_tag|
    where("tag_id = ? and level = ?", _tag, 5)
  }

  validates_presence_of :content, :time, :tag_id
  validates :content, length: {minimum: 5}
  validates :level, inclusion: {in: (1..LEVELNUM)}
  validates :time, inclusion: {in: TIMERANGE}
  paginates_per 10

  def self.collect_by_degree_and_tag(degree, tag_id, _offset)
    questions = case degree
                when Degree::TYPE::BEGINNER
                  Question.for_beginner(tag_id)
                when Degree::TYPE::INTERMEDIATE
                  Question.for_intermediate(tag_id)
                when Degree::TYPE::SENIOR
                  Question.for_senior(tag_id)
                when Degree::TYPE::MASTER
                  Question.for_master(tag_id)
                when Degree::TYPE::LEGENDARY
                  Question.for_legendary(tag_id)
                end

    questions.with_answers.limit(QUESTIONNUM_EACHREQUEST).offset(_offset) if questions
  end
end
