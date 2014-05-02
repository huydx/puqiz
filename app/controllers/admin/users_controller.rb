class Admin::UsersController < Admin::ApplicationController
  def new
    @user = AdminUser.new
  end

  def create
    @user = AdminUser.new(params[:admin_user])

    if @user.save
      redirect_to root_url
    else
      render action: :new
    end
  end
end
