class UsersController < ApplicationController
  protect_from_forgery :except => [:create]

  def create
    user = User.find_by_name(verified_user_params[:name])
    if user
      user.generate_token && user.save
      render_user_json_success and return
    else
      user = User.create(verified_user_params)
      if user.errors
        render_user_json_failed and return
      else
        render_user_json_success and return
      end
    end
  rescue Exception => e
    logger.error(e)
    render json: {status: "failed"}
  end

  private
  def render_user_json_failed
    render json: {status: "failed", data: {message: u.errors.messages.as_json}}
  end

  def render_user_json_success
    render json: {status: "success", data: {id: u.id, name: u.name, token: u.token, provider: u.provider}}
  end
  
  def verified_user_params
    #do some verify
    {name: params["name"], provider: params["provider"], uuid: params["uuid"]}
  end
end
