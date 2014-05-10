class Api::QuestionResultsController < Api::ApplicationController
  def create
    qid = params[:question_id]
    uid = current_user.id
    result = params[:result]
    QuestionResult.create(question_id: qid, user_id: uid, result: result)
  end

  def batch_create
    if new_degree = update_user_degree
      render json: {status: "success", data: {degree: new_degree.content}} 
    else 
      render json: {status: "failed"} 
    end
  end

  private
  def update_user_degree
    tag_id = params[:tag_id] || Tag::DEFAULT_TAG
    current_user.update_degree(tag_id)
  end
end
