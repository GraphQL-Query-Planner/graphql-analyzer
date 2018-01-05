require 'spec_helper'

shared_examples 'an instrumented field' do
  let(:user) { create(:user, :with_posts) }
  let(:query_string) { %|{ node(id: "#{user.to_global_id}") { id } }| }
  let(:schema) { AppSchema.redefine { use(GraphQL::Analyzer.new([GraphQL::Analyzer::ActiveRecordInstrumentation.new])) } }
  let(:result) do
    res = schema.execute(query_string, context: {}, variables: {})
    pp res if res.key?('errors')
    res
  end

  it 'captures db queries' do
    expected = result['extensions']['analyzer']['execution']['resolvers']
    binding.pry
    expect(expected).not_to be_empty
  end
end

DB_CONFIGS.each do |adapter, config|
  describe "graphql fields backed by #{adapter}" do
    ActiveRecord::Base.establish_connection(DB_CONFIGS[adapter][RAILS_ENV])
    it_behaves_like 'an instrumented field'
    ActiveRecord::Base.establish_connection(DB_CONFIGS['mysql'][RAILS_ENV])
  end
end
