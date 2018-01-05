require 'active_record'
require 'support/active_record/models/application_record.rb'

RAILS_ENV = ENV['RAILS_ENV'] || 'test'
DB_CONFIGS = {}
GlobalID.app = 'GraphQL-Analyzer'

Dir.glob(File.join('spec', 'support', 'active_record', '**', '*.rb')).each do |filename|
  require(filename.gsub('spec/', ''))
end

Dir.glob(File.join('spec', 'support', 'active_record', 'config', '*.yml')).each do |filename|
  DB_CONFIGS[File.basename(filename, '.yml')] = YAML.load(File.read(filename))
end

ActiveRecord::Base.establish_connection(DB_CONFIGS['mysql'][RAILS_ENV])
