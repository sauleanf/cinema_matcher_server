# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FriendRequest, type: :model do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:friend_request) { FriendRequest.create(user: user, other_user: other_user) }

  describe 'FriendRequest#pending?' do
    context 'when the request is pending' do
      it 'returns true' do
        expect(friend_request.pending?).to be(true)
      end
    end

    context 'when the request is not pending' do
      it 'returns false' do
        [
          FriendRequest::Status::ACCEPTED,
          FriendRequest::Status::REJECTED,
          FriendRequest::Status::RESCINDED
        ].each do |status|
          friend_request.update(status: status)

          expect(friend_request.pending?).to be(false)
        end
      end
    end
  end

  describe 'FriendRequest#rejected?' do
    context 'when the request is rejected' do
      before do
        friend_request.update(status: FriendRequest::Status::REJECTED)
      end

      it 'returns true' do
        expect(friend_request.rejected?).to be(true)
      end
    end

    context 'when the request is not pending' do
      it 'returns false' do
        [
          FriendRequest::Status::ACCEPTED,
          FriendRequest::Status::PENDING,
          FriendRequest::Status::RESCINDED
        ].each do |status|
          friend_request.update(status: status)

          expect(friend_request.rejected?).to be(false)
        end
      end
    end
  end

  describe 'FriendRequest#accepted?' do
    context 'when the request is accepted' do
      before do
        friend_request.update(status: FriendRequest::Status::ACCEPTED)
      end

      it 'returns true' do
        expect(friend_request.accepted?).to be(true)
      end
    end

    context 'when the request is not accepted' do
      it 'returns false' do
        [
          FriendRequest::Status::PENDING,
          FriendRequest::Status::REJECTED,
          FriendRequest::Status::RESCINDED
        ].each do |status|
          friend_request.update(status: status)

          expect(friend_request.accepted?).to be(false)
        end
      end
    end
  end

  describe 'FriendRequest#rescinded?' do
    context 'when the request is rescinded' do
      before do
        friend_request.update(status: FriendRequest::Status::RESCINDED)
      end

      it 'returns true' do
        expect(friend_request.rescinded?).to be(true)
      end
    end

    context 'when the request is not rescinded' do
      it 'returns false' do
        [
          FriendRequest::Status::ACCEPTED,
          FriendRequest::Status::PENDING,
          FriendRequest::Status::REJECTED
        ].each do |status|
          friend_request.update(status: status)

          expect(friend_request.rescinded?).to be(false)
        end
      end
    end
  end

  describe 'validate' do
    it 'does not allow reflexive friend requests' do
      invalid_friend_request = FriendRequest.new(user: user, other_user: user)

      expect(invalid_friend_request.valid?).to be(false)
    end
  end
end
