# frozen_string_literal: true

require_relative 'application'

Rails.application.configure do
  config.autoload_paths << Rails.root.join('lib')
  config.autoload_paths << Rails.root.join('db/seeders')
end

Rails.application.initialize!
