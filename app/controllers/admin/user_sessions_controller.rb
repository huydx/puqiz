class Admin::UserSessionsController < Admin::ApplicationController
  before_filter :authenticate_admin_user!, except: [:new, :create]

  def new
    redirect_to admin_questions_path if logged_in?
    @session = AdminUserSession.new
  end

  def create
    @session = AdminUserSession.new(params[:admin_user_session])
    if @session.save
      redirect_to admin_questions_path
    else
      render :action => 'new'
    end
  end

  def destroy
    @session = AdminUserSession.find
    @session.destroy
    redirect_to admin_questions_path
  end
end
