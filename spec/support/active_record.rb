require 'active_record'

GlobalID.app = 'GraphQL-Analyzer'

Dir.glob(File.join('spec', 'support', 'active_record', '**', '*.rb')).each do |filename|
  require(filename.gsub('spec/', ''))
end

ActiveRecord::Base.establish_connection(
  adapter:  'mysql2',
  host:     'localhost',
  username: 'root',
  password: '',
  database: 'graphql_analyzer_test'
)
