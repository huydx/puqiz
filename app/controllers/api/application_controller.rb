class Api::ApplicationController < ApplicationController
  before_filter :authenticate_user!

  protected
  def authenticate_user!
    render_unauthenticate and return unless params[:token] && params[:uid]
    @user = User.find_by_id(params[:uid])
    render_unauthenticate and return unless user && user.token == params[:token]
  end

  def render_unauthenticate
    render json: {status: "unauthenticated token"}
  end

  def current_user
    @user
  end
end
