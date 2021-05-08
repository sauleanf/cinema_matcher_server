# frozen_string_literal: true

NECESSARY_CONFIGS = [
  'smtp.yml'
].freeze

NECESSARY_ENVS = %w[
  AWS_REGION
  AWS_ACCESS_KEY_ID
  AWS_SECRET_ACCESS_KEY
].freeze

namespace :setup do
  desc 'Setups the application'
  task all: :environment do
    Rake::Task['setup:check_configs'].execute
    Rake::Task['setup:check_environment'].execute
    Rake::Task['setup:sqs'].execute
  end

  task check_configs: :environment do
    NECESSARY_CONFIGS.each do |config_filename|
      raise "Missing #{config_filename} config file" unless File.file?(File.join('config', config_filename))
    end
    puts 'All config files are present'
  end

  task check_environment: :environment do
    NECESSARY_ENVS.each do |env|
      key_present = ENV[env]
      raise "#{env} is not set" unless key_present
    end
    puts 'All environment variables are set'
  end

  task sqs: :environment do
    config = YAML.load_file(File.join('config', 'shoryuken.yml'))
    config['queues'].each do |queue, _frequency|
      system "shoryuken sqs create #{queue}"
    end
  end
end
