# frozen_string_literal: true

Rails.application.routes.draw do
  root to: proc { [200, {}, ['']] }
  scope 'api/v1' do
    resources :users, only: %i[index create]
    scope 'users' do
      get 'self', to: 'users#show'
      put 'edit', to: 'users#edit'
      get 'friends', to: 'users#friends'
    end

    resources :recommendations, only: %i[index show create]
    resources :registrations, only: %i[index]

    scope 'registrations' do
      put '', to: 'registrations#update'
    end

    resources :directors
    resources :pictures

    scope 'auth' do
      post 'login', to: 'auth#login'
      scope 'google' do
        post 'login', to: 'auth#google_login'
      end
    end

    scope 'friends' do
      get '', to: 'friends#index'

      scope 'requests' do
        get '/:id', to: 'friend_requests#show'
      end

      scope 'sent' do
        get '', to: 'sent_friend_requests#index'
        post '', to: 'sent_friend_requests#create'
        delete '/:id', to: 'sent_friend_requests#rescind'
      end

      scope 'incoming' do
        get '', to: 'incoming_friend_requests#index'
        put '/:id', to: 'incoming_friend_requests#accept'
        delete '/:id', to: 'incoming_friend_requests#reject'
      end
    end

    resources :rooms, only: %i[index show create]

    scope 'rooms' do
      post 'add', to: 'rooms#add'
      post '/:id/start', to: 'rooms#start'
    end
  end

  post 'login', to: 'auth#login'

  mount ActionCable.server, at: '/cable'
end
