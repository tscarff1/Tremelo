Rails.application.routes.draw do
  get 'notifications/destroy'

  resources :tags

  get 'user_bands/destroy'

  get 'user_bands/edit'

  get "/login" => "user_sessions#new", as: :login
  get "/register" => "users#new", as: :register
  get "/logout" => "user_sessions#destroy", as: :logout
  delete "/logout" => "user_sessions#destroy"

  get 'users/leave_band' => "users#leave_band"
  get 'users/:id/upload_pic' => "users#upload_pic"
  get 'users/nearby_users' => "users#index"

  get 'users/:id/edit_tags' => "users#edit_tags"
  get 'users/:id/access_error' => 'users#access_error'

  get 'search_user' => 'users#search'
  get 'users/search_results' => 'users#search_results'

  get 'bands/:id/upload_pic' => 'bands#upload_pic'
  get 'bands/:id/access_error' => 'bands#access_error'
  get 'bands/:id/search_for_user' => 'bands#search_for_user'
  get 'bands/:id/edit_videos' => 'bands#edit_videos', as: :edit_videos
  get '/fetch_videos' => 'band_videos#from_video', as: 'fetch_videos'
  get '/fetch_musics' => 'band_musics#from_music', as: 'fetch_musics'

  get 'search_user' => 'users#search'
  get 'users/search_results' => 'users#search_results'

  get 'search_band' => 'bands#search'
  get 'bands/search_results' => 'bands#search_results'
  
  resources :users do
    member do
      put 'update_pic'
    end
    collection do
      get 'notifications'
      put 'update_tags'
      get 'search'
      post 'search_results'
      get 'accept_band'
    end
  end

  get 'notifications/destroy' => 'notifications#destroy', as: 'destroy_notification'

  resources :messages do
    collection do
      get '/send_message', to: 'messages#new', as: 'new_message'
      put '/create', to: 'messages#create'
    end
  end

  resources :bands do
    resource :band_videos
    member do
      get 'search_for_user'
      get 'new_search_for_user'
      post 'user_search_results'
      get 'user_search_results'
      put 'add_member'
      get 'edit_videos'
      get 'edit_musics'
      get 'edit_genres'
      put 'update_genres'
      put 'update_videos'
      get 'delete_videos'
      put 'destroy_videos'
      put 'update_musics'
      get 'delete_musics'
      put 'destroy_musics'
    end
    collection do
      post 'upload_pic'
      get 'search'
      post 'search_results'

    end

    collection do
      get 'access_error'
    end
  end
  resources :userbands
  resources :usertags

  resources :user_sessions, only: [:new, :create]
  resources :password_resets, only: [:new, :create, :edit, :update]

  root 'static_pages#home'

  get 'about' => 'static_pages#about'
  get 'help' => 'static_pages#help'

  get 'help/creating_account' => 'static_pages/help#creating_account'
  get 'help/basic_site_nav' => 'static_pages/help#basic_site_nav'
  get 'help/editing_profile' => 'static_pages/help#editing_profile'

  resources :static_pages

  resources :videos

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
