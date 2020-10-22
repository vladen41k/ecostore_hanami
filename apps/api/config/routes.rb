# frozen_string_literal: true

# Configure your routes here
# See: https://guides.hanamirb.org/routing/overview
#
# Example:
# get '/hello', to: ->(env) { [200, {}, ['Hello from Hanami!']] }

# Sidekiq::Web.set :session_secret, ENV['WEB_SESSIONS_SECRET']

resources :products, only: %i[index show]
resources :categories, only: %i[index show]
resources :order_items, only: %i[create destroy]

post '/sign_up', to: 'users#create', as: :sign_up
post '/sign_in', to: 'users#create_session', as: :sign_in
patch '/confirm_email/:token', to: 'users#confirm_email', as: :confirm_email
patch '/order_formation/:id', to: 'order#order_formation', as: :order_formation
