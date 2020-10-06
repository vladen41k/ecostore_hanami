# Configure your routes here
# See: https://guides.hanamirb.org/routing/overview
#
# Example:
# get '/hello', to: ->(env) { [200, {}, ['Hello from Hanami!']] }

resources :products, only: %i[index show create update]
resources :categories, only: %i[index show create]
resources :order_items, only: %i[create delete]

post '/sign_up', to: 'users#create', as: :sign_up
post '/sign_in', to: 'users#create_session', as: :sign_in
patch '/confirm_email/:token', to: 'users#confirm_email', as: :confirm_email
