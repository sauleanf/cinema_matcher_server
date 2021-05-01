# frozen_string_literal: true

class Registration < ApplicationRecord
  belongs_to :user
  before_create :generate_code

  def confirmed?
    confirmed_at != nil
  end

  def confirm!
    update!(confirmed_at: DateTime.now)
    user.update!(confirmed_email: true)
  end

  private

  def generate_code
    self.code = rand(1..999_999)
  end
end
