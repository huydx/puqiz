class Api::QuestionsController < Api::ApplicationController
  protect_from_forgery except: [:index]
  def index
    tag = params[:tag] || Tag::DEFAULT_TAG
    deg = current_user.degree_by_tag(tag)
    render json: {status: "success"}
  end
end
