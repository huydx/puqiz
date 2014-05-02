class UsersController < ApplicationController
  protect_from_forgery :except => [:create]

  def create
    u = User.create(verified_user_params)
    render json: {status: "success", id: u.id, token: u.token}
  rescue Exception => e
    logger.error(e)
    render json: {status: "failed"}
  end

  private
  def verified_user_params
    #do some verify
    {name: params["name"], provider: params["provider"], uuid: params["uuid"]}
  end
end
