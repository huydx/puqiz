class Question < ActiveRecord::Base
  attr_accessible :content, :tag_id, :level, :time, :answers_attributes
  has_many :answers, dependent: :destroy
  has_one :tag
  accepts_nested_attributes_for :answers, reject_if: lambda { |a| a[:content].blank? }
  LEVELNUM = 5
  TIMERANGE = [2, 3, 5, 10, 15]
  ANSWERNUM = 4

  validates_presence_of :content, :time, :tag_id
  validates :content, length: {minimum: 5}
  validates :level, inclusion: {in: (1..LEVELNUM)}
  validates :time, inclusion: {in: TIMERANGE}
  paginates_per 50

  def collect_by_degree(degree, tag)
    #[TODO] fix hardcode string
    
    case degree
    when "beginner"
    when "intermediate"
    when "senior"
    when "master"
    when "legendary"
    end
  end
end
