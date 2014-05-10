class Api::TagsController < ApplicationController
  def index
    @tags = Tag.all  
    render json: {status: "success", data: @tags.as_json(except: [:created_at, :updated_at])}
  rescue Exception => e
    logger.error(e.message)
    render json: {status: "failed"}
  end
end
