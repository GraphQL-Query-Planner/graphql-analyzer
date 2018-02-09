require 'spec_helper'

shared_examples 'a parser' do
  it 'produces an explainer result' do
    explain_output = Post.where(author_id: 1).explain
    expect(parser.parse(explain_output)).to be_kind_of GraphQL::Analyzer::Result
  end
end

DB_CONFIGS.each do |adapter, config|
  describe "GraphQL::Analyzer::Parser::#{adapter.camelize}" do
    let(:parser) { "GraphQL::Analyzer::Parser::#{adapter.camelize}".constantize }

    before :all do
      ActiveRecord::Base.establish_connection(config[RAILS_ENV])
      ActiveRecord::Migrator.migrate('spec/support/active_record/db/migrate/', nil)
    end

    after :all do
      ActiveRecord::Base.establish_connection(DB_CONFIGS['mysql'][RAILS_ENV])
    end

    it_behaves_like 'a parser'
  end
end
