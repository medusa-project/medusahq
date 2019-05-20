Rails.application.routes.draw do
  root 'landing#index'

  match '/health', to: 'health#show', as: :health, via: :get

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :collections, param: :uuid
  resources :repositories, param: :uuid do
    get :edit_ldap_admins, on: :collection
    put :update_ldap_admin, on: :member
  end
  resources :access_systems
  
  #auth routes
  match '/auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match '/login', to: 'sessions#new', as: :login, via: [:get, :post]
  match '/logout', to: 'sessions#destroy', as: :logout, via: [:get, :post]

end
