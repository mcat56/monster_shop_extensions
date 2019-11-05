Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/', to: "welcome#index"

  resources :merchants do
    resources :items, only: [:index, :new, :create]
  end

  resources :items, except: [:new] do
    resources :reviews, only: [:new, :create]
  end

  resources :users do
    resources :addresses
  end

  resources :reviews, only: [:edit, :update, :destroy]
  resources :orders

  post "/cart/:item_id", to: "cart#add_item"
  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"
  patch "/cart/:item_id/:increment_decrement", to: "cart#increment_decrement"
  post '/cart', to: "cart#show"


  get '/profile/orders', to: 'orders#index'
  get '/profile/orders/:order_id', to: 'orders#show'
  delete '/cancel/:order_id', to: 'orders#destroy'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get '/register', to: 'users#new'
  post '/users', to: 'users#create'
  get '/profile/:user_id', to: 'users#show'
  get '/profile/:user_id/edit', to: 'users#edit'
  put '/profile/:user_id', to: 'users#update'
  get '/profile/:user_id/edit/password', to: 'users#edit'
  patch '/profile/:user_id/password', to: 'users#update'


  namespace :admin do
    get '/users', to: 'users#index'
    get '/users/:user_id', to: 'users#show'
    get '/users/:user_id/edit', to: 'users#edit'
    put '/users/:user_id', to: 'users#update'
    # resources :users, except: [:destroy, :new]
    get '/users/:user_id/edit/password', to: 'users#edit'
    patch '/users/:user_id/password', to: 'users#update'
    get '/users/:user_id/edit_role', to: 'users#edit_role'
    patch '/users/:user_id/upgrade', to: 'users#upgrade'
    get '/merchants/:merchant_id', to: 'merchants#show'
    patch '/merchants/:merchant_id/update_status', to: 'merchants#update_status'
    get '/orders/:order_id/ship', to: 'orders#ship'
    get '/', to: 'dashboard#show'
    get '/users/:user_id/enable', to: 'users#change_active_status'
    get '/users/:user_id/disable', to: 'users#change_active_status'
  end

  scope :admin do
    get '/merchants/:merchant_id/items', to: 'merchant/items#index'
  end

  get '/users/:user_id/orders/:order_id/add_coupon', to: 'orders#add_coupon'



  namespace :merchant do
    get '/', to: 'dashboard#show'
    get '/coupons/:id/toggle_coupon', to: 'coupons#toggle'
    # resources :items
    get '/items', to: 'items#index'
    get '/items/new', to: 'items#new'
    post '/items', to: 'items#create'
    get '/items/:item_id/edit', to: 'items#edit'
    patch '/items/:item_id', to: 'items#update'
    delete '/items/:item_id', to: 'items#destroy'

    get '/items/:item_id/deactivate', to: 'items#update_status'
    get '/items/:item_id/activate', to: 'items#update_status'
    get '/orders/:order_id', to: 'orders#show'
    get '/item_orders/:item_order_id/fulfill', to: 'item_orders#fulfill'

    resources :coupons

  end

end
