require 'spec_helper'

describe Explainer::ExplainedQuery do
  it 'the query is indexed' do
    output = Post.where(author_id: 1).explain
    result = Explainer::Parser.parse(output)
    expect(result.queries.first).to be_indexed
  end

  it 'the query isnt indexed' do
    output = Post.where(author_id: 1).from("#{Post.table_name} IGNORE INDEX(index_posts_on_author_id)").explain
    result = Explainer::Parser.parse(output)
    expect(result.queries.first).not_to be_indexed
  end
end
