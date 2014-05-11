class Api::QuestionsController < Api::ApplicationController
  protect_from_forgery except: [:index]
  def index
    tag_id = (params[:tag_id] || Tag::DEFAULT_TAG).to_i
    offset = (params[:offset] || 0).to_i
    deg = Degree.find_by_user_id_and_tag_id(current_user.id, tag_id)
    questions = Question.collect_by_degree_and_tag(deg.type, tag_id, offset)
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
