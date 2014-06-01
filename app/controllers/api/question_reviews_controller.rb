class Api::QuestionsController < Api::ApplicationController
  protect_from_forgery except: [:create]

  def create
    @question_review = QuestionReview.create(params[:question_review])
    if @question_review.errors.empty?
      render json: {status: true}
    else
      render json: {status: false}
    end 
  rescue Exception => e
    logger.error(e.backtrace.join('\n'))
    render json: {status: false}
  end
end
