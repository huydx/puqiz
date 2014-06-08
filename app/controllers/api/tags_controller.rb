class Api::TagsController < Api::ApplicationController
  def index
    asking_date       = params[:date]
    asking_date       = DateTime.parse(asking_date)
    recent_db_update  = RecentlyUpdateTag.maximum(:updated_at)
    
    @tags = Tag.updated_after(asking_date)
    render json: {status: true, data: @tags.as_json(except: [:created_at, :updated_at])}
  rescue Exception => e
    logger.error(e.message)
    render json: {status: false}
  end
end
