Rails.application.routes.draw do
  get 'user_bands/destroy'

  get 'user_bands/edit'

  get "/login" => "user_sessions#new", as: :login
  get "/register" => "users#new", as: :register
  get "/logout" => "user_sessions#destroy", as: :logout
  delete "/logout" => "user_sessions#destroy"
  
  get 'users/leave_band' => "users#leave_band"
  get 'users/upload_pic' => "users#upload_pic"
 
  get 'users/:id/upload_pic' => 'users#upload_pic'

  resources :users do
    collection do
      put 'update_pic'
    end
  end
  resources :user_sessions, only: [:new, :create]
  resources :password_resets, only: [:new, :create, :edit, :update]

  root 'static_pages#home'

  get 'about' => 'static_pages#about'
  get 'help' => 'static_pages#help'

  resources :bands
  resources :videos
  resources :userbands
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
