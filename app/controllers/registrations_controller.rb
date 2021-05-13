# frozen_string_literal: true

class RegistrationsController < ApplicationController
  before_action :authorized?, only: %i[update index]
  before_action :registration, only: %i[update index]

  def index
    render json: @registration.decorate
  end

  def update
    if @registration.code == submitted_code
      @registration.confirm!

      RegistrationMailer.with(user: @current_user).confirmed_email.deliver_later

      render json: @registration.decorate, status: :ok
    else
      render json: { code: Messages::REGISTRATION_FAILED }, status: :unprocessable_entity
    end
  end

  private

  def registration
    @registration = Registration.find_by(user: current_user)
  end

  def submitted_code
    @submitted_code ||= Integer(params[:code])
  end
end
