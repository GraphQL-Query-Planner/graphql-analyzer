require 'spec_helper'

describe GraphQL::Analyzer::Instrumentation::Postgresql do
  before :all do
    ActiveRecord::Base.establish_connection(DB_CONFIGS['postgresql'][RAILS_ENV])
    ActiveRecord::MigrationContext.new('spec/support/active_record/db/migrate/').migrate
  end

  after :all do
    ActiveRecord::Base.establish_connection(DB_CONFIGS['mysql'][RAILS_ENV])
  end

  let(:field) do
    field = GraphQL::Field.new
    field.resolve = ->(obj, args, ctx) { User.first }
    field
  end
  let(:instrumentation) { GraphQL::Analyzer::Instrumentation::Postgresql.new }
  let(:instrumented_proc) { instrumentation.instrument(OpenStruct.new(name: 'TypeName'), field) }
  let(:mock_ctx) { MockContext.new(path: ['user']) }

  context '#instrument' do
    it 'should have explained the query' do
      instrumented_proc.call(nil, nil, mock_ctx)
      results = mock_ctx.dig('graphql-analyzer', 'resolvers', 0, 'details', 0)
      explained_query = results.explained_queries.first

      expect(explained_query).to match 'Index Scan using users_pkey on users'
    end

    it 'should have captured the query made' do
      instrumented_proc.call(nil, nil, mock_ctx)
      results = mock_ctx.dig('graphql-analyzer', 'resolvers', 0, 'details', 0)

      expect(results.root).to match /SELECT.*FROM.*users/
    end
  end
end
