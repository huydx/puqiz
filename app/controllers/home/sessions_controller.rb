class Home::SessionsController < Home::ApplicationController
  def create
    auth_hash = request.env["omniauth.auth"]
    user = User.find_for_twitter_oauth(auth_hash)
    if user
      UserSession.create(user, true)
      redirect_to home_index_path
    else
      redirect_to home_register_information_path
    end
  end

  def destroy
    current_user_session.destroy 
    redirect_to home_index_path
  end
end
