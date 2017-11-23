require 'factory_bot'
require 'factories/user'
require 'factories/post'
require 'factories/comment'

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
