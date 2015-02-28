Rails.application.routes.draw do
  root 'pages#index'

  resources :boards, only: [:create, :new]
  resources :users,  only: [:create, :show]

  get '/auth/:provider/callback' => 'sessions#create'
  get '/signin'                  => 'sessions#new',     :as => :signin
  get '/signout'                 => 'sessions#destroy', :as => :signout
  get '/auth/failure'            => 'sessions#failure'
end
