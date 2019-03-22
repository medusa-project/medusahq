Rails.application.routes.draw do
  root 'landing#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :collections, param: :uuid
  resources :repositories, param: :uuid

  #auth routes
  match '/auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match '/login', to: 'sessions#new', as: :login, via: [:get, :post]
  match '/logout', to: 'sessions#destroy', as: :logout, via: [:get, :post]

end
