class Api::QuestionResultsController < Api::ApplicationController
  def create
    qid = params[:question_id]
    uid = current_user.id
    result = params[:result]
    QuestionResult.create(question_id: qid, user_id: uid, result: result)
  end

  def batch_create
    #need to talk with ios side
  end
end
