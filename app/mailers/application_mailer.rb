# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@cinemamatcher.com'
  layout 'mailer'
end
