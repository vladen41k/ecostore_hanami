# Configure your routes here
# See: https://guides.hanamirb.org/routing/overview
#
# Example:
# get '/hello', to: ->(env) { [200, {}, ['Hello from Hanami!']] }

resources :products, only: %i[index show create update]
resources :categories, only: %i[index show create]
# resources :users, only: %i[create]
post '/sign_up', to: 'users#create'
post '/sign_in', to: 'users#create_session'
