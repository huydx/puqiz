class Answer < ActiveRecord::Base
  attr_accessible :content, :flag, :question_id
  belongs_to :question, dependent: :destroy
end
