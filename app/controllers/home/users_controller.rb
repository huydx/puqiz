class Home::UsersController < Home::ApplicationController
  before_filter :require_log_in
  def index
    @degrees = Degree.where(user_id: current_user.id)
  end

  def contribute_question
  end

  def contribute_guide
  end
end
