class Api::AnalyticController < Api::ApplicationController
  RANKING_LIMIT_DEFAULT = 30
  OFFSET_DEFAULT        = 0

  def ranking_all
    limit   = (params[:limit]   || RANKING_LIMIT_DEFAULT).to_i
    offset  = (params[:offset]  || OFFSET_DEFAULT).to_i
    raise Exception, "Must have tag_id" unless params[:tag_id]
    tag_id  = params[:tag_id].to_i

    top_degrees = Degree.top(tag_id, limit, offset)
    uids = top_degrees.collect(&:user_id)
    points = top_degrees.collect(&:accumulate_point)

    users =  User.sort_with_array(uids)
    users.zip(points).map {|u,p| u["accumulate_point"] = p}

    render json: {status: true, data: users.as_json(except: [:created_at, :updated_at, :token, :uuid])}
  rescue Exception=>e
    logger.error(e.backtrace.join("\n"))
    render json: {status: false}
  end
end
