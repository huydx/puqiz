class Home::SessionsController < Home::ApplicationController
  skip_before_filter :require_log_in, only: [:create, :destroy]
    
  def create
    auth_hash = request.env["omniauth.auth"]
    if auth_hash["provider"] == "twitter"
      user = User.find_for_twitter_oauth(auth_hash)
    elsif auth_hash["provider"] == "facebook"
      user = User.find_for_facebook_oauth(auth_hash)
    end
    
    if user
      UserSession.create(user, true)
      redirect_to home_users_index_path
    else
      redirect_to home_register_information_path
    end
  end

  def destroy
    current_user_session.destroy 
    redirect_to home_index_path
  end
end
