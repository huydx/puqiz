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
  end
  match "/auth/:provider/callback" => "home/sessions#create"

  namespace :api do
    resources :questions
    resources :question_results do
      collection do
        post 'batch_create'
      end
    end
    resources :tags
    get 'analytic/ranking', to: 'analytic#ranking_ll'
  end

  resources :users do
    collection do
      post 'create'
    end
  end


  root :to => 'admin::questions#new'
end
