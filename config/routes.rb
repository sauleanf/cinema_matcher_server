Rails.application.routes.draw do
  resources :directors
  resources :pictures
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope 'api/v1' do
    resources :users
    scope 'users' do
      post 'follow', to: 'users#follow'
    end

    scope 'rooms' do
      get 'index', to: 'rooms#index'
      get 'show', to: 'rooms#show'
      post 'create', to: 'rooms#create'
    end
  end

  post 'login', to: 'auth#login'
end
