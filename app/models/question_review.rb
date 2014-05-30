class QuestionReview < ActiveRecord::Base
  acts_as :question
  attr_accessible :answer_reviews_attributes
  has_many :answer_reviews, dependent: :destroy
  after_save :skip_validation

  protected
  def should_validate_question
    false
  end
end
