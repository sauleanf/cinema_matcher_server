require 'bcrypt'

class User < ApplicationRecord
  include BCrypt

  validates :fullname, presence: true
  validates :hashed_password, presence: true
  validates :username, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, presence: true

  has_many :follower_followings, class_name: 'Following', foreign_key: 'follower_id'
  has_many :followee_followings, class_name: 'Following', foreign_key: 'followee_id'

  has_many :followers, class_name: 'User', through: :followee_followings
  has_many :followees, class_name: 'User', through: :follower_followings

  has_many :rooms
  has_many :room_users

  def follow(followee_id)
    Following.create!(follower_id: id, followee_id: followee_id)
  end

  def password
    @password ||= Password.new(hashed_password)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.hashed_password = @password
  end

  def acquaintances
    followees | followers
  end
end
