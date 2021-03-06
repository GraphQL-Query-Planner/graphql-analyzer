require "bundler/setup"
require 'pry-byebug'
require "graphql"
require 'globalid'
require 'graphql/analyzer'
require 'support/factory_bot'
require 'support/active_record'
require 'support/graphql'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  # config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
