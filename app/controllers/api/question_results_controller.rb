class Api::QuestionResultsController < Api::ApplicationController
  def create
    qid = params[:question_id]
    uid = current_user.id
    result = params[:result]
    QuestionResult.create(question_id: qid, user_id: uid, result: result)
  end

  def batch_create
    correct_ids = params[:data][:correct_questions]
    failed_id = params[:data][:failed_question]

    unless correct_ids.empty?
      correct_ids.each do |id|
        update_correct_question(id.to_i)  
      end
    end

    if failed_id.to_i > 0
      update_failed_question(failed_id.to_i)
    end

    if new_degree = update_user_degree
      render json: {status: true, data: {degree: new_degree.type}} 
    else 
      render json: {status: false} 
    end
  rescue Exception => e
    logger.error(e.message)
    render json: {status: false} 
  end

  private
  def update_correct_question(id)
    if correct_question = QuestionResult.find_by_question_id(id)
      correct_question.result = "true"
      correct_question.save
    else
      QuestionResult.create(question_id: id.to_i, user_id: current_user.id, result: "true") 
    end
  end

  def update_failed_question(id)
    if failed_question = QuestionResult.find_by_question_id(id)
      failed_question.result = "false"
      failed_question.save
    else
      QuestionResult.create(question_id: id.to_i, user_id: current_user.id, result: "false")
    end
  end

  def update_user_degree
    tag_id = params[:tag_id] || Tag::DEFAULT_TAG
    current_user.update_degree(tag_id)
  end
end
