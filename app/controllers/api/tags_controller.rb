class Api::TagsController < ApplicationController
  def index
    @tags = Tag.all  
    render json: {status: true, data: @tags.as_json(except: [:created_at, :updated_at])}
  rescue Exception => e
    logger.error(e.message)
    render json: {status: false}
  end
end
