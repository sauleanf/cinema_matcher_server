# frozen_string_literal: true

class RegistrationMailer < ApplicationMailer
  default from: 'noreply@cinemamatcher.com'

  def welcome_email
    @user = params[:user]
    @registration = @user.registration
    mail(to: @user.email, subject: 'Welcome to Cinema Matcher')
  end

  def confirmed_email
    @user = params[:user]
    mail(to: @user.email, subject: 'Email Address Confirmed!')
  end
end
