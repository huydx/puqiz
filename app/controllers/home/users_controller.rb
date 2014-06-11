class Home::UsersController < Home::ApplicationController
  before_filter :require_log_in
  before_filter :prepare_question_form, only: [:index]

  def index
    @has_navigation = true
    @degrees = Degree.where(user_id: current_user.id)
    @credits = Credit.order('question_number DESC').limit(100)
  end

  def download_template
    filepath = Rails.root.join('public', 'question_template.xls')
    template = File::stat(filepath)
    send_file(filepath, :filename => 'question_template.xls', :length => template.size) 
  end

  protected
  def prepare_question_form
    @question = QuestionReview.new
    Question::ANSWERNUM.times { @question.answer_reviews.build }
    @tags = Tag.all.map{|t| [t.content, t.id]}
    @timerange = Question::TIMERANGE
  end
end
