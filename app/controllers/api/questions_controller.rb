class Api::QuestionsController < Api::ApplicationController
  protect_from_forgery except: [:index]
  def index
    _tag_id = (params[:tag_id] || Tag::DEFAULT_TAG).to_i
    _offset = (params[:offset] || 0).to_i
    _limit = (params[:limit] || Question::QUESTION_PER_REQUEST).to_i
    questions = Question.where(tag_id: _tag_id).limit(_limit).offset(_offset)

    render json: {status: true, data: questions.as_json(include: :answers, except: [:created_at, :updated_at])}
  rescue Exception => e
    logger.error(e.message)
    render json: {status: false}
  end

  def show
    raise Exception.new("id parameter is null") unless params[:id]
    @question = Question.find_by_id(params[:id].to_i)
    render layout: false
  rescue Exception => e
    logger.error(e.message)
    render text: "Loading failed"
  end
end
