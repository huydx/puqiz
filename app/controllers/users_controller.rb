class UsersController < ApplicationController
  protect_from_forgery :except => [:create]

  def create
    @user = User.find_by_name(verified_user_params[:name])
    if @user
      @user.update_attributes!(verified_user_params)
      render_user_json_success and return
    else
      @user = User.create(verified_user_params)
      if @user.errors.messages.empty?
        render_user_json_success and return
      else
        render_user_json_failed and return
      end
    end
  rescue Exception => e
    logger.error(e)
    render json: {status: false, data: {message: e}} and return
  end

  private
  def render_user_json_failed
    render json: {status: false, data: {message: @user.errors.messages.as_json}}
  end

  def render_user_json_success
    render json: {
      status: true, 
      data: @user.as_json(except: [:created_at, :updated_at, :uuid])
    }
  end
  
  def verified_user_params
    {
      name: params["name"],
      fullname: params["fullname"],
      provider: params["provider"], 
      uuid: params["uuid"],
      avatar: params["avatar"]
    }
  end
end
