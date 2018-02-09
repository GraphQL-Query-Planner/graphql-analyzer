require 'spec_helper'

describe GraphQL::Analyzer::Instrumentation::Mysql do
  before :all do
    ActiveRecord::Base.establish_connection(DB_CONFIGS['mysql'][RAILS_ENV])
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
  let(:instrumentation) { GraphQL::Analyzer::Instrumentation::Mysql.new }
  let(:instrumented_proc) { instrumentation.instrument(OpenStruct.new(name: 'TypeName'), field) }
  let(:mock_ctx) { MockContext.new(path: ['user']) }

  context '#instrument' do
    it 'should have explained the query' do
      instrumented_proc.call(nil, nil, mock_ctx)
      results = mock_ctx.dig('graphql-analyzer', 'resolvers', 0, 'details')
      explained_query = results.explained_queries.first

      expect(explained_query['select_type']).to eq 'SIMPLE'
      expect(explained_query['table']).to eq 'users'
    end

    it 'should have captured the query made' do
      instrumented_proc.call(nil, nil, mock_ctx)
      results = mock_ctx.dig('graphql-analyzer', 'resolvers', 0, 'details')

      expect(results.root).to match /SELECT.*FROM.*users/
    end
  end
end
