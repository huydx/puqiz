class Admin::UserReportsController < Admin::ApplicationController
  PERPAGE = 20;
  def index
    @reports = UserReport.all
  end

  def delete
    UserReport.find_by_id(params[:id]).delete
    redirect_to action: 'index'
  rescue
  end
end
