class Api::QuestionsController < Api::ApplicationController
  protect_from_forgery except: [:index]
  def index
    tag_id = params[:tag_id] || Tag::DEFAULT_TAG
    deg = current_user.degree_by_tag(tag_id)
    questions = Question.collect_by_degree_and_tag(deg, tag_id)
    render json: {status: "success", data: questions.to_json(include: :answers)}
  end
end
