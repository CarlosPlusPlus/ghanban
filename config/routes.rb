Rails.application.routes.draw do
  root 'pages#index'

  resources :boards
  resources :users,  only: [:create, :show]
  resource :github_webhooks, only: :create, defaults: { formats: :json }

  get '/auth/:provider/callback' => 'sessions#create'
  get '/signin'                  => 'sessions#new',     :as => :signin
  get '/signout'                 => 'sessions#destroy', :as => :signout
  get '/auth/failure'            => 'sessions#failure'
end
