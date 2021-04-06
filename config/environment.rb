# frozen_string_literal: true

# Load the Rails application.
require_relative 'application'

Rails.application.configure do
  config.autoload_paths << "#{Rails.root}/lib"
end

# Initialize the Rails application.
Rails.application.initialize!
