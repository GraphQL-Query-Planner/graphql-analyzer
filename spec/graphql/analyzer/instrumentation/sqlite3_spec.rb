require 'spec_helper'

describe GraphQL::Analyzer::Instrumentation::Sqlite3 do
  before :all do
    ActiveRecord::Base.establish_connection(DB_CONFIGS['sqlite3'][RAILS_ENV])
    ActiveRecord::Migrator.migrate('spec/support/active_record/db/migrate/', nil)
  end

  after :all do
    ActiveRecord::Base.establish_connection(DB_CONFIGS['mysql'][RAILS_ENV])
  end

  let(:field) do
    field = GraphQL::Field.new
    field.resolve = ->(obj, args, ctx) { User.first }
    field
  end
  let(:instrumentation) { GraphQL::Analyzer::Instrumentation::Sqlite3.new }
  let(:instrumented_proc) { instrumentation.instrument(OpenStruct.new(name: 'TypeName'), field) }
  let(:mock_ctx) { MockContext.new(path: ['user']) }

  context '#instrument' do
    it 'should have explained the query' do
      instrumented_proc.call(nil, nil, mock_ctx)
      results = mock_ctx.dig('graphql-analyzer', 'resolvers', 0, 'details', 0)
      explained_query = results.explained_queries.first

      expect(explained_query['details']).to eq 'SCAN TABLE users'
    end

    it 'should have captured the query made' do
      instrumented_proc.call(nil, nil, mock_ctx)
      results = mock_ctx.dig('graphql-analyzer', 'resolvers', 0, 'details', 0)

      expect(results.root).to match /SELECT.*FROM.*users/
    end
  end
end
