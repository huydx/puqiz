class Api::QuestionsController < Api::ApplicationController
  protect_from_forgery except: [:index]
  def index
    tag_id = (params[:tag_id] || Tag::DEFAULT_TAG).to_i
    offset = (params[:offset] || 0).to_i
    deg = current_user.degree_by_tag(tag_id)
    questions = Question.collect_by_degree_and_tag(deg, tag_id, offset)
    render json: {status: "success", data: questions.to_json(include: :answers)}
  rescue
    render json: {status: "failed"}
  end
end
