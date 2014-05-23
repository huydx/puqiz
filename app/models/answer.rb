class Answer < ActiveRecord::Base
  attr_accessible :content, :flag, :question_id
  before_save :santinize_flag
  belongs_to :question, dependent: :destroy

  protected
  def santinize_flag
    self.flag = flag.nil? ? 0 : 1
  end
end
