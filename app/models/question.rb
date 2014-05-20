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

  TIMERANGE = [2, 3, 5, 10, 15]
  ANSWERNUM = 4
  QUESTION_PER_REQUEST = 20
  
  scope :with_answers, lambda { includes(:answers) }

  validates_presence_of :content, :time, :tag_id
  validates :content, length: {minimum: 5}
  validates :level, inclusion: {in: (1..LEVELNUM)}
  validates :time, inclusion: {in: TIMERANGE}
  paginates_per 10 #paginate at admin page
end
