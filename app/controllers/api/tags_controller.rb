class Api::TagsController < Api::ApplicationController
  layout false

  def index
    asking_date       = params[:date]
    asking_date       = DateTime.parse(asking_date)
    recent_db_update  = RecentlyUpdateTag.maximum(:updated_at)
    
    @tags = Tag.updated_after(asking_date)
    @tags = @tags.each do |t| 
      t["full_image_path"] = URI.join(root_url, t.image.url).to_s
      t.explaination_url = URI.join(root_url, t.explaination_url).to_s if t.explaination_url
    end
    render json: {status: true, data: @tags.as_json(except: [:created_at, :updated_at])}
  rescue Exception => e
    logger.error(e.message)
    render json: {status: false}
  end

  def explaination
    tag_id = params[:id] || Tag::DEFAULT_TAG
    @tag = Tag.find_by_id(tag_id)
  end
end
