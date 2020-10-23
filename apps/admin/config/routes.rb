# frozen_string_literal: true

require 'sidekiq/web'

# Configure your routes here
# See: https://guides.hanamirb.org/routing/overview
#
# Example:
# get '/hello', to: ->(env) { [200, {}, ['Hello from Hanami!']] }

mount Sidekiq::Web, at: '/sidekiq'

resources :admins, only: %i[update]
post '/sign_up', to: 'admins#create', as: :sign_up_admin
post '/sign_in', to: 'admins#create_session', as: :sign_in_admin
patch 'admins/update_password/:id', to: 'admins#update_password', as: :admin_update_password

resources :categories, only: %i[index show create update]
resources :orders, only: %i[index]
patch 'orders/canceled/:id', to: 'orders#canceled', as: :canceled_order
patch 'orders/completed/:id', to: 'orders#completed', as: :completed_order

resources :products, only: %i[index show create update]
resources :users, only: %i[update]
