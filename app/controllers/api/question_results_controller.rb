class Api::QuestionResultsController < Api::ApplicationController
  before_filter :init_current_degree

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
    if correct_questions && !correct_questions.empty?
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
      result = make_return_hash
      render json: {status: true, data: result.as_json} 
    else 
      render json: {status: false} 
    end
  rescue Exception => e
    logger.error(e.backtrace.join('\n'))
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
    return @current_degree.increment_point_by!(@point)
  end

  protected
  def init_current_degree
    tag_id = params[:tag_id] || Tag::DEFAULT_TAG
    @current_degree = Degree.find_by_user_id_and_tag_id(current_user.id, tag_id)
  end

  def make_return_hash
    {
      increment_point:          @point,
      accumulate_point:         @current_degree.accumulate_point,
      level_point:              @current_degree.point,
      point_until_next_level:   @current_degree.point_until_next_level,
      point_until_down_level:   @current_degree.point_until_down_level,
      degree:                   @current_degree.type
    }
  end
end
