# frozen_string_literal: true

class RegistrationsController < ApplicationController
  before_action :authorized?, only: %i[update show]
  before_action :registration, only: %i[update show]

  def show
    render json: @registration.decorate
  end

  def update
    if @registration.code == submitted_code
      registration.confirm!

      RegistrationMailer.with(user: @current_user).confirmed_email.deliver_later

      render json: { message: Messages::REGISTRATION_COMPLETED }, status: :ok
    else
      render json: { message: Messages::REGISTRATION_FAILED }, status: :unprocessable_entity
    end
  end

  private

  def registration
    @registration = @current_user.registration
  end

  def submitted_code
    @submitted_code ||= Integer(params[:code])
  end
end
