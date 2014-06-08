Puqiz::Application.routes.draw do
  namespace :admin do
    resources :questions do
      get 'delete'
    end
    resources :user_sessions
    resources :users
    resources :tags do
      get 'delete'
    end
    resources :question_reviews do
      member do
        post 'verify'
      end
      get 'delete'
    end
    post 'markdown', to: "markdown#rendering"
    get 'log_out', to: "user_sessions#destroy"
  end
  
  namespace :home do
    match "/signout" => "sessions#destroy"
    get "index" => "application#index"
    get "register_information" => "application#register_information"
    namespace :users do
      get "index"
      get "contribute_question"
      get "contribute_guide"
    end
  end
  match "/auth/:provider/callback" => "home/sessions#create"

  namespace :api do
    resources :questions do
      collection do
        get 'check_update'
      end
    end
    resources :question_results do
      collection do
        post 'batch_create'
      end
    end
    resources :tags do
      collection do
        get 'check_update'
      end
    end
    get 'analytic/ranking', to: 'analytic#ranking_all'
  end

  resources :users do
    collection do
      post 'create'
    end
  end


  root :to => 'home::application#index'
end
