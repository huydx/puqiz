class QuestionReview < ActiveRecord::Base
  attr_accessible :content, :tag_id, :level, :time, :answer_reviews_attributes, :url, :explaination, :user_id
  has_many :answer_reviews, dependent: :destroy

  accepts_nested_attributes_for :answer_reviews, reject_if: lambda { |a| a[:content].blank? }
  paginates_per 10
end
