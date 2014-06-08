class Api::QuestionsController < Api::ApplicationController
  protect_from_forgery except: [:index]
  def index
    _tag_id = (params[:tag_id] || Tag::DEFAULT_TAG).to_i
    _offset = (params[:offset] || 0).to_i
    _level  = (params[:level] || Question::DEFAULT_LEVEL).to_i 
    _limit  = (params[:limit] || Question::QUESTION_PER_REQUEST).to_i
    questions = Question.includes(:answers).where(tag_id: _tag_id, level: _level).limit(_limit).offset(_offset)

    render json: {status: true, data: questions.as_json(include: :answers, except: [:created_at, :updated_at])}
  rescue Exception => e
    logger.error(e.backtrace.join('\n'))
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

  def check_update
    date    = params[:date]
    tag_id  = params[:tag_id] || Tag::DEFAULT_TAG
    asking_date       = ActiveSupport::TimeWithZone.new(asking_date)
    recent_db_update  = RecentlyUpdateQuestion.find_by_tag_id(tag_id).updated_at
    render json: {status: true, data: {is_update: recent_db_update > asking_date}}
  rescue Exception => e
    render json: {status: false}
  end
end
