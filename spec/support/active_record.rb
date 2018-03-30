require 'active_record'
require 'support/active_record/models/application_record.rb'

RAILS_ENV = ENV['RAILS_ENV'] || 'test'
DB_CONFIGS = {}
GlobalID.app = 'GraphQL-Analyzer'

Dir.glob(File.join('spec', 'support', 'active_record', 'config', '*.yml')).each do |filename|
  DB_CONFIGS[File.basename(filename, '.yml')] = YAML.load(File.read(filename))
end

Dir.glob(File.join('spec', 'support', 'active_record', '**', '*.rb')).each do |filename|
  require(filename.gsub('spec/', ''))
end

ActiveRecord::Migration.verbose = false

DB_CONFIGS.each do |adapter, config|
  ActiveRecord::Base.establish_connection(config[RAILS_ENV])
  ActiveRecord::Migrator.migrate('spec/support/active_record/db/migrate/', nil)
end

ActiveRecord::Base.establish_connection(DB_CONFIGS['mysql'][RAILS_ENV])
