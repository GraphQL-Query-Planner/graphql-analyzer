require 'spec_helper'

shared_examples 'an instrumented field' do
  let(:user) { create(:user, :with_posts) }
  let(:query_string) { %|{ node(id: "#{user.to_global_id}") { id } }| }
  let(:schema) { AppSchema.redefine { use(GraphQL::Analyzer.new([GraphQL::Analyzer::Instrumentation::MySQL.new])) } }
  let(:result) do
    res = schema.execute(query_string, context: {}, variables: {})
    pp res if res.key?('errors')
    res
  end

  it 'captures db queries' do
    expected = result['extensions']['analyzer']['execution']['resolvers']
    expect(expected).not_to be_empty
  end
end

DB_CONFIGS.each do |adapter, config|
  describe "graphql fields backed by #{adapter}" do
    before :all do
      ActiveRecord::Base.establish_connection(config[RAILS_ENV])
      ActiveRecord::Migrator.migrate('spec/support/active_record/db/migrate/', nil)
    end

    after :all do
      ActiveRecord::Base.establish_connection(DB_CONFIGS['mysql'][RAILS_ENV])
    end

    it_behaves_like 'an instrumented field'
  end
end
