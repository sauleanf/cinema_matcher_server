# frozen_string_literal: true

require 'bcrypt'

class User < ApplicationRecord
  include BCrypt

  validates :fullname, presence: true
  validates :hashed_password, presence: true
  validates :username, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, presence: true

  has_many :room_users, dependent: :destroy
  has_many :rooms, through: :room_users

  has_many :friendships, foreign_key: :first_user_id, inverse_of: :second_user, dependent: :destroy
  has_many :friends, class_name: 'User', through: :friendships, source: :second_user

  has_many :friend_requests, dependent: :destroy
  has_many :pending_friends, class_name: 'User', through: :friend_requests

  def password
    @password ||= Password.new(hashed_password)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.hashed_password = @password
  end

  def send_friend_request(other_user)
    friend_request = FriendRequest.new(user: self, other_user: other_user)

    return { error: friend_requests.errors } unless friend_request.save

    { friend_request: friend_request }
  end

  def accept_friend_request(friend_request)
    return { error: 'Other user must confirm the request' } unless friend_request.other_user == self

    friendship = Friendship.new(first_user: self, second_user: friend_request.user)
    symmetric_friendship = Friendship.new(first_user: friend_request.user, second_user: self)

    return { error: friendship.errors } unless friendship.save
    return { error: symmetric_friendship.errors } unless symmetric_friendship.save

    friend_request.status = FriendRequest::Status::ACCEPTED
    friend_request.save!

    { friendship: friendship, symmetric_friendship: symmetric_friendship }
  end

  def sent_pending_friend_requests
    friend_requests.where(status: FriendRequest::Status::PENDING)
  end

  def incoming_pending_friend_requests
    FriendRequest.where(other_user: self, status: FriendRequest::Status::PENDING)
  end

  def self.from_omniauth(auth)
    where(email: auth.info.email).first_or_create! do |user|
      user.fullname = auth.info.name
      user.email = auth.info.email
    end
  end
end
