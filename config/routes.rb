Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope 'api/v1' do
    resources :users
    scope 'users' do
      post 'follow', to: 'users#follow'
    end
  end

  post 'login', to: 'auth#login'
end
