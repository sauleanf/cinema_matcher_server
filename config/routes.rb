# frozen_string_literal: true

Rails.application.routes.draw do
  root to: proc { [200, {}, ['']] }
  scope 'api/v1' do
    resources :users, only: %i[index create]
    resources :recommendations, only: %i[index show create]
    resources :registrations, only: %i[show]

    scope 'registrations' do
      put '', to: 'registrations#update'
    end

    scope 'users' do
      put 'edit', to: 'users#edit'
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
      scope 'sent' do
        get '', to: 'sent_friend_requests#index'
        post '', to: 'sent_friend_requests#create'
        delete '', to: 'sent_friend_requests#rescind'
      end

      scope 'incoming' do
        get '', to: 'incoming_friend_requests#index'
        put '', to: 'incoming_friend_requests#accept'
        delete '', to: 'incoming_friend_requests#reject'
      end
    end

    resources :rooms, only: %i[index show create]

    scope 'rooms' do
      post 'add', to: 'rooms#add'
    end
  end

  post 'login', to: 'auth#login'
end
