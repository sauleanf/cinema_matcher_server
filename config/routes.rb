# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope 'api/v1' do
    resources :users
    resources :directors
    resources :pictures

    scope 'friends' do
      scope 'sent' do
        get 'index', to: 'sent_friend_requests#index'
        delete 'rescind', to: 'sent_friend_requests#rescind'
      end

      scope 'incoming' do
        get 'index', to: 'incoming_friend_requests#index'
        put 'accept', to: 'incoming_friend_requests#accept'
        delete 'reject', to: 'incoming_friend_requests#reject'
      end
    end

    scope 'rooms' do
      get 'index', to: 'rooms#index'
      get 'show', to: 'rooms#show'
      post 'create', to: 'rooms#create'

      scope 'add' do
        post 'add', to: 'rooms#add'
      end
    end
  end

  post 'login', to: 'auth#login'
end
