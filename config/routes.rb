Rails.application.routes.draw do
  resources :tags

  get 'user_bands/destroy'

  get 'user_bands/edit'

  get "/login" => "user_sessions#new", as: :login
  get "/register" => "users#new", as: :register
  get "/logout" => "user_sessions#destroy", as: :logout
  delete "/logout" => "user_sessions#destroy"

  get 'users/nearby_users' => "users#index"

  get '/fetch_musics' => 'band_musics#from_music', as: 'fetch_musics'

  get 'search_band' => 'bands#search'
  get 'bands/search_results' => 'bands#search_results'
  
  resources :users, param: :display_name do
    member do
      get 'upload_pic'
      put 'update_pic'
      get 'edit_tags'
    end
    collection do
      get 'notifications'
      put 'update_tags'
      get 'search_user'
      get 'search_results'
      post 'search_results'
      get 'accept_band'
      get 'leave_band'
      get 'access_error'
    end
  end

  resources :searches do
    collection do
      get 'create'
      get 'delete'
      get 'new'
    end
  end

  resources :notifications do
    member do
      get "destroy", as: "destroy"
    end
    collection do
      get "new"
      post "new"
    end
  end

  resources :messages do
    collection do
      get '/send_message', to: 'messages#new', as: 'new_message'
      put '/create', to: 'messages#create'
    end
  end

  resources :bands, param: :name do

    member do
      get 'fetch_videos'
      get 'search_for_user'
      get 'new_search_for_user'
      post 'user_search_results'
      get 'user_search_results'
      put 'add_member'
      get 'upload_pic'
      get 'edit_videos'
      get 'edit_musics'
      get 'edit_genres'
      put 'update_genres'
      put 'update_musics'
      get 'delete_musics'
      put 'destroy_musics'
    end
    collection do
      get 'search_for_user'
      get 'search'
      post 'search_results'
      get 'access_error'
    end 

    resources :band_videos do
      member do
        get 'new_band_setup'
        
      end
    end
    resources :band_musics do
      collection do
          get 'new_band_setup'
          get 'edit'
      end
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
