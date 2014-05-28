class Api::AnalyticController < Api::ApplicationController
  RANKING_LIMIT_DEFAULT = 30
  OFFSET_DEFAULT        = 0

  def ranking_all
    limit   = (params[:limit]   || RANKING_LIMIT_DEFAULT).to_i
    offset  = (params[:offset]  || OFFSET_DEFAULT).to_i
    raise Exception, "Must have tag_id" unless params[:tag_id]
    tag_id  = params[:tag_id].to_i

    top_ids = Degree.top(tag_id, limit, offset).collect(&:user_id)
    users =  User.find(top_ids, order: "field(id, #{top_ids.join(',')})")
    render json: {status: true, data: users.as_json(except: [:created_at, :updated_at, :token, :uuid])}
  rescue Exception=>e
    logger.error(e.backtrace.join("\n"))
    render json: {status: false}
  end
end
