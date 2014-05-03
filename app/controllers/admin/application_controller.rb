class Admin::ApplicationController < ApplicationController
  protect_from_forgery
  before_filter :authenticate_admin_user!
  
  protected
  def authenticate_admin_user!
    unless (current_user && current_user.admin?)
      redirect_to new_admin_user_session_path
    end
  end

  def current_user
    ret = defined?(@current_user) ? @current_user : nil
    @current_user = current_user_session && current_user_session.record
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = AdminUserSession.find
  end

  def logged_in?
    !!current_user
  end
end
