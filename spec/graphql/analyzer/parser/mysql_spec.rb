require 'spec_helper'

describe GraphQL::Analyzer::Parser::MySQL do
  it 'produces an explainer result' do
    explain_output = Post.where(author_id: 1).explain
    expect(GraphQL::Analyzer::Parser::MySQL.parse(explain_output)).to be_kind_of GraphQL::Analyzer::Result
  end
end
