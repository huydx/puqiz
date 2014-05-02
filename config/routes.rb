Puqiz::Application.routes.draw do
  namespace :admin do
    resources :questions
    resources :user_sessions
    resources :users
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

  root :to => 'admin::questions#new'
end
