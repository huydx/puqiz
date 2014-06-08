class Question < ActiveRecord::Base
  attr_accessible :content, :tag_id, :level, :time, :answers_attributes, :url
  has_many :answers, dependent: :destroy
  has_one :tag
  before_save :create_html_content
  before_save :touch_recently_update_question
  accepts_nested_attributes_for :answers, reject_if: lambda { |a| a[:content].blank? }, allow_destroy: true

  LEVELNUM = 5
  DEFAULT_LEVEL = 1

  TIMERANGE = (1..60) 
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
  validate :has_correct_answers

  paginates_per 10 #paginate at admin page

  def after_initialize 
    return unless new_record?
    self.level = 1
  end

protected
  def number_of_questions
    msg = "You must have at least two answers"
    errors.add(:base, msg) if answers.size < 2
  end

  def has_correct_answers
    msg = "You must have at least one correct answers"
    correct_answers = answers.find_all { |ans| ans.flag.to_i == 1 }
    errors.add(:base, msg) if !correct_answers || correct_answers.size < 1
  end

  def create_html_content
    self.html_content = $markdown.render(self.content)
  end

  def touch_recently_update_question
    RecentlyUpdateQuestion.find_or_create_by(tag_id: self.tag_id) do |r|
      r.question_id = self.id
    end
  end
end
