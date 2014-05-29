Puqiz::Application.routes.draw do
  namespace :admin do
    resources :questions do
      get 'delete'
    end
    resources :user_sessions
    resources :users
    post 'markdown', to: "markdown#rendering"
  end

  namespace :api do
    resources :questions
    resources :question_results do
      collection do
        post 'batch_create'
      end
    end
    resources :tags
  end

  resources :users do
    collection do
      post 'create'
    end
  end

  get 'log_out', to: "admin/user_sessions#destroy"

  post 'api/analytic/ranking', to: "api/analytic#ranking_all"

  root :to => 'admin::questions#new'
end
