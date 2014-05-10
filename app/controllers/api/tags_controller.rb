class Api::TagsController < ApplicationController
  def index
    @tags = Tags.all  
    render json: {status: "success", data: @tags}
  rescue
    render json: {status: "failed"}
  end
end
