class Api::TagsController < ApplicationController
  def index
    @tags = Tag.all  
    render json: {status: true, data: @tags.as_json(except: [:created_at, :updated_at])}
  rescue Exception => e
    logger.error(e.message)
    render json: {status: false}
  end

  def check_update
    date    = params[:date]
    tag_id  = params[:tag_id] || Tag::DEFAULT_TAG
    asking_date       = ActiveSupport::TimeWithZone.new(asking_date)
    recent_db_update  = RecentlyUpdateTag.find_by_tag_id(tag_id).updated_at
    render json: {status: true, data: {is_update: recent_db_update > asking_date}}
  rescue Exception => e
    render json: {status: false}
  end
end
