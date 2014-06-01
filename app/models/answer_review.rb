class AnswerReview < ActiveRecord::Base
  attr_accessible :content, :flag, :question_review_id
  belongs_to :question_review, dependent: :destroy
end
