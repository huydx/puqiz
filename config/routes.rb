Puqiz::Application.routes.draw do
  namespace :admin do
    resources :questions do
      get 'delete'
    end
    resources :user_sessions
    resources :users
    resources :question_results
  end

  namespace :api do
    resources :questions
    resources :tags
  end

  resources :users do
    collection do
      post 'create'
    end
  end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end
  get 'log_out', to: "admin/user_sessions#destroy"
  root :to => 'admin::questions#new'
end
