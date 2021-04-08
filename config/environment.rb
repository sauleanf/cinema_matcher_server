# frozen_string_literal: true

# Load the Rails application.
require_relative 'application'

Rails.application.configure do
  config.autoload_paths << "#{Rails.root}/lib"
  config.autoload_paths << "#{Rails.root}/db/seeders"
end

# Initialize the Rails application.
Rails.application.initialize!
