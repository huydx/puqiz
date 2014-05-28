class Api::QuestionResultsController < Api::ApplicationController
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
        @point = @point + Question::LEVEL_SCORE_MAP[q['level'].to_s]
        update_correct_question(ActiveSupport::HashWithIndifferentAccess.new(q))
      end
    end
    
    if failed_question
      @point = @point - Question::LEVEL_SCORE_MAP[failed_question['level'].to_s]
      update_failed_question(ActiveSupport::HashWithIndifferentAccess.new(failed_question))
    end
    
    if new_degree_and_point = update_user_point_and_degree
      render json: {status: true, data: new_degree_and_point} 
    else 
      render json: {status: false} 
    end
  rescue Exception => e
    logger.error(e.backtrace)
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
    current_degree.increment_point_by!(@point)
    return {point: current_degree.point, degree: current_degree.type}
  end

  protected
  def current_degree
    tag_id = params[:tag_id] || Tag::DEFAULT_TAG
    Degree.find_by_user_id_and_tag_id(current_user.id, tag_id)
  end
end
