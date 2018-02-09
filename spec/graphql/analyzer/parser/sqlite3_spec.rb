require 'spec_helper'

describe GraphQL::Analyzer::Parser::Sqlite3 do
  before :all do
    ActiveRecord::Base.establish_connection(DB_CONFIGS['sqlite3'][RAILS_ENV])
    ActiveRecord::Migrator.migrate('spec/support/active_record/db/migrate/', nil)
  end

  after :all do
    ActiveRecord::Base.establish_connection(DB_CONFIGS['mysql'][RAILS_ENV])
  end

  it 'produces an explainer result' do
    explain_output = Post.where(author_id: 1).explain
    expect(GraphQL::Analyzer::Parser::Sqlite3.parse(explain_output)).to be_kind_of GraphQL::Analyzer::Result
  end
end
