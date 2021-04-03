class Following < ApplicationRecord
  belongs_to :followee, class_name: 'User', foreign_key: :followee_id, dependent: :destroy
  belongs_to :follower, class_name: 'User', foreign_key: :follower_id, dependent: :destroy

  validates :followee, presence: true
  validates :follower, presence: true
end
