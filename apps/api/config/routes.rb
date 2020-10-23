# frozen_string_literal: true

# Configure your routes here
# See: https://guides.hanamirb.org/routing/overview
#
# Example:
# get '/hello', to: ->(env) { [200, {}, ['Hello from Hanami!']] }

# Sidekiq::Web.set :session_secret, ENV['WEB_SESSIONS_SECRET']

resources :categories, only: %i[index show]

resources :orders, only: %i[index show]
patch 'orders/current_order', to: 'orders#current_order', as: :current_order
patch 'orders/canceled/:id', to: 'orders#canceled', as: :order_canceled
patch 'orders/order_formation/:id', to: 'orders#order_formation', as: :order_formation

resources :order_items, only: %i[create destroy]

post 'payments/create/:id', to: 'payments#create', as: :payments

resources :products, only: %i[index show]

resources :users, only: %i[update]
post '/sign_up', to: 'users#create', as: :sign_up
post '/sign_in', to: 'users#create_session', as: :sign_in
patch '/confirm_email/:token', to: 'users#confirm_email', as: :confirm_email
patch 'users/update_password/:id', to: 'users#update_password', as: :user_update_password
