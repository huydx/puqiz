class Question < ActiveRecord::Base
  attr_accessible :content, :tag_id, :level, :time, :answers_attributes, :url
  has_many :answers, dependent: :destroy
  has_one :tag
  before_save :create_html_content
  accepts_nested_attributes_for :answers, reject_if: lambda { |a| a[:content].blank? }

  LEVELNUM = 5
  DEFAULT_LEVEL = 1

  TIMERANGE = [2, 3, 5, 10, 15]
  ANSWERNUM = 4
  QUESTION_PER_REQUEST = 20

  LEVEL_SCORE_MAP = {
    "1" => 50,
    "2" => 90,
    "3" => 150,
    "4" => 200,
    "5" => 300
  }
  
  scope :with_answers, lambda { includes(:answers) }

  validates_presence_of :content, :time, :tag_id
  validates_format_of :url, with: URI.regexp(['http', 'https']), allow_nil: true, allow_blank: true
  validates :content, length: {minimum: 5}
  validates :level, inclusion: {in: (1..LEVELNUM)}
  validates :time, inclusion: {in: TIMERANGE}
  validate :number_of_questions

  paginates_per 10 #paginate at admin page

  def after_initialize 
    return unless new_record?
    self.level = 1
  end

protected
  def number_of_questions
    errors.add(:base, "You must have at least two answers") if answers.size < 2
  end

  def create_html_content
    self.html_content = $markdown.render(self.content)
  end
end
