class Home::ApplicationController < ApplicationController
  protect_from_forgery
  helper_method :current_user
  before_filter :require_log_in, except: [:index, :register_information]
  layout "home/application"
  
  def index; end

  def register_information; end

  private
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def require_log_in
    unless current_user
      redirect_to home_index_path
    end
  end
end
