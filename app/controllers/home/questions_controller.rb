class Home::QuestionsController < Home::ApplicationController
  def create
    @question_review = QuestionReview.create(params[:question_review])
    @question_review.update_attributes(user_id: current_user.id)
    if @question_review.errors.empty?
      render json: {status: true}
    else
      render json: {status: false}
    end 
  rescue Exception => e
    logger.error(e.backtrace.first(5).join("\n"))
    render json: {status: false}
  end
end
