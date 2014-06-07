class Home::UsersController < Home::ApplicationController
  before_filter :require_log_in
  def index
  end

  def contribute_question
  end

  def contribute_guide
  end
end
