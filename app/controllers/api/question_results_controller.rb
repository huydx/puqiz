class Api::QuestionResultsController < Api::ApplicationController
  after_filter :update_user_score_and_point

  def create
    qid = params[:question_id]
    uid = current_user.id
    result = params[:result]
    QuestionResult.create(question_id: qid, user_id: uid, result: result)
  end

  def batch_create
    correct_questions = params[:data][:correct_questions]
    failed_question = params[:data][:failed_question]
    @point = 0

    unless correct_questions.empty?
      correct_questions.each do |q|
        @point = @point + Question::LEVEL_SCORE_MAP[q.level.to_s]
        update_correct_question(ActiveSupport::HashWithIndifferentAccess.new(q))
      end
    end
    
    if failed_question
      @point = @point - Question::LEVEL_SCORE_MAP[q.level.to_s]
      update_failed_question(ActiveSupport::HashWithIndifferentAccess.new(failed_question))
    end
    
    if new_degree = update_user_point_and_degree
      render json: {status: true, data: {degree: new_degree.type}} 
    else 
      render json: {status: false} 
    end
  rescue Exception => e
    logger.error(e.message)
    render json: {status: false} 
  end

  protected
  def update_correct_question(result_params)
    result_params.merge!(result: "true", user_id: current_user.id)
    update_question_result(result_params)
  end

  def update_failed_question(result_params)
    result_params.merge!(result: "false", user_id: current_user.id)
    update_question_result(result_params)
  end

  def update_question_result(result_params)
    if result = QuestionResult.find_by_question_id(result_params[:question_id])
      result.update_attributes!(result_params)
    else
      QuestionResult.create(result_params) 
    end
  end
  
  def update_user_point_and_degree
    update_user_point
    return update_user_degree
  end

  def update_user_point
    current_user.increment_point!(@point)
  end

  def update_user_degree
    return Degree.update_for_user!(current_user) 
  end
end
