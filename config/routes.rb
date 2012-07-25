Gramicon::Application.routes.draw do

  resources :credit_transactions

  resources :folders

  devise_for :users

  resources :messages

  resources :users

  match 'profile' => 'users#edit', :as => :edit_profile

  match 'messages/:id/:state' => 'messages#update_state', :as => :update_message_state, :via => :put
  # match 'messages/:id/hold' => 'messages#hold', :as => :hold_message, :via => :put
  # match 'users/:id/inbox' => 'users#inbox', :as => :user_inbox
  # match 'inbox/:folder_id' => 'users#inbox', :as => :folder_inbox
  match 'inbox' => 'users#inbox', :as => :inbox
  match 'inbox/:type_name' => 'users#inbox', :as => :type_inbox
  match 'inbox/folders/:folder_id' => 'users#inbox', :as => :folder_inbox

  root :to => "home#index"

  resources :messages do
    resources :ratings
  end


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

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

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
