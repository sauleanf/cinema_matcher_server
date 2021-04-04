# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:num_friends) { 4 }
  let!(:sent_pending_friend_requests) do
    num_friends.times.map do
      new_user = create(:user)
      FriendRequest.create(user: user, other_user: new_user)
    end
  end
  let!(:incoming_pending_friend_requests) do
    num_friends.times.map do
      new_user = create(:user)
      FriendRequest.create(user: new_user, other_user: user)
    end
  end
  let!(:non_pending_friend_requests) do
    [
      FriendRequest::Status::ACCEPTED,
      FriendRequest::Status::REJECTED,
      FriendRequest::Status::RESCINDED
    ].map do |status|
      new_user = create(:user)
      FriendRequest.create(user: user, other_user: new_user, status: status)
    end
  end

  before do
    user.reload
  end

  context 'User#password' do
    let!(:new_password) { 'new_password' }

    it 'overrides the user password' do
      user.password = new_password
      expect(user.password).to eq(new_password)
    end
  end

  context 'User#send_friend_request' do
    it 'creates a friend request' do
      user.send_friend_request(other_user)
      friend_request = FriendRequest.last
      expect(friend_request).to have_attributes(user: user, other_user: other_user)
    end
  end

  context 'User#send_friend_request' do
    before do
      user.send_friend_request(other_user)
    end

    it 'creates a friend request with the right associations' do
      friend_request = FriendRequest.last
      expect(friend_request.user).to eq(user)
      expect(friend_request.other_user).to eq(other_user)
    end
  end

  context 'User#accept_friend_request' do
    let!(:friend_request) { FriendRequest.create(user: user, other_user: other_user) }

    before do
      other_user.accept_friend_request(friend_request)
      friend_request.reload
    end

    it 'creates a friend request' do
      friendship = Friendship.find_by(first_user: user, second_user: other_user)
      symmetric_friendship = Friendship.find_by(first_user: other_user, second_user: user)

      expect(friendship).to be_truthy
      expect(symmetric_friendship).to be_truthy
    end

    it 'sets the friend request status to accepted' do
      expect(friend_request.accepted?).to be(true)
    end
  end

  context 'User#rooms' do
    let(:room) do
      room = Room.new
      room.users << user
      room.save!

      user.reload

      room
    end

    it 'shows the users rooms' do
      expect(user.rooms).to include(room)
    end
  end

  context 'User#sent_pending_friend_requests' do
    it 'shows all of the sent pending friend requests' do
      expect(user.sent_pending_friend_requests).to match_array(sent_pending_friend_requests)
    end
  end

  context 'User#incoming_sent_friend_requests' do
    it 'shows all of the sent pending friend requests' do
      expect(user.incoming_pending_friend_requests).to match_array(incoming_pending_friend_requests)
    end
  end
end
