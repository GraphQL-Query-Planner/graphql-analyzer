require 'spec_helper'

shared_examples 'an instrumented schema' do
  let(:user) { create(:user, :with_posts) }
  let(:query_string) { %|{ node(id: "#{user.to_global_id}") { id } }| }
  let(:schema) do
    analyzer = GraphQL::Analyzer.new([instrumentation])
    AppSchema.redefine { use(analyzer) }
  end
  let(:result) do
    res = schema.execute(query_string, context: {}, variables: {})
    pp res if res.key?('errors')
    res
  end  

  it 'captures db queries' do
    expected = result['extensions']['analyzer']['execution']['resolvers']
    expect(expected).not_to be_empty
  end

  it 'provides details about the query' do
    expected = result.dig('extensions', 'analyzer', 'execution', 'resolvers', 0, 'details')
    expect(expected).not_to be_nil
  end
end

shared_examples 'an instrumented field' do
  let(:field) do
    field = GraphQL::Field.new
    field.resolve = ->(obj, args, ctx) { User.first }
    field
  end
  let(:instrumented_proc) { instrumentation.instrument(OpenStruct.new(name: 'TypeName'), field) }
  let(:mock_ctx) { MockContext.new(path: ['user']) }

  it 'should return a graphql field' do
    expect(instrumented_proc).to be_kind_of Proc
  end

  it 'should return the same value as the uninstrumented field' do
    expected = field.resolve(nil, nil, mock_ctx)
    expect(expected).to eq instrumented_proc.call(nil, nil, mock_ctx)
  end

  it 'should capture queries made when resolved in the ctx' do
    expect(mock_ctx['graphql-analyzer']['resolvers']).to be_empty
    instrumented_proc.call(nil, nil, mock_ctx)
    expect(mock_ctx['graphql-analyzer']['resolvers']).not_to be_empty
  end
end

DB_CONFIGS.each do |adapter, config|
  describe "graphql fields backed by #{adapter}" do
    let(:instrumentation) { "GraphQL::Analyzer::Instrumentation::#{adapter.camelize}".constantize.new }

    before :all do
      ActiveRecord::Base.establish_connection(config[RAILS_ENV])
      ActiveRecord::Migrator.migrate('spec/support/active_record/db/migrate/', nil)
    end

    after :all do
      ActiveRecord::Base.establish_connection(DB_CONFIGS['mysql'][RAILS_ENV])
    end

    it_behaves_like 'an instrumented schema'
    it_behaves_like 'an instrumented field'
  end
end
