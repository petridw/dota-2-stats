
Rails.application.routes.draw do

#application
  root 'livematches#index'
  get '/about' => 'application#about', as: :about

#users
  get '/signup' => 'users#new', as: :signup
  post '/users' => 'users#create'
  get '/settings' => 'users#settings', as: :settings
  get '/unlinksteam' => 'users#unlinkSteam', as: :unlink_steam

# sessions
  get '/login' => 'sessions#new', as: :login
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy', as: :logout

# livegames
  get '/livematches' => 'livematches#index', as: :live_matches
  get '/livematches/:id' => 'livematches#show', as: :live_match

# mygames
  get '/matches' => 'matches#index', as: :matches
  get '/matches/:id' => 'matches#show', as: :match
  get '/matches/pro' => 'matches#pro', as: :promatches


# steam
  post 'auth/steam/callback' => 'steam#auth_callback'

# leagues
  get '/leagues' => 'leagues#index', as: :leagues

# proplayers
  get '/proplayers' => 'proplayers#index', as: :proplayers
  get '/proplayers/:id' => 'proplayers#show', as: :proplayer

# resources, so far only users needs all resources
  resources :users

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
