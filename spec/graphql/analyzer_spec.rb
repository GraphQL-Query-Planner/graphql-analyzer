require 'spec_helper'

describe Graphql::Analyzer do
  let(:user) { create(:user, :with_posts) }
  let(:query_string) { %|{ userA: user(id: "#{user.to_global_id}") { posts { id }  } }| }
  let(:analyzer) { Graphql::Analyzer.new(AppSchema) }
  let(:result) do
    res = analyzer.execute(query_string, context: {}, variables: {})
    pp res if res.key?('errors')
    res
  end

  it 'should work' do
    expect(result['extensions']['analyzer']).to be_kind_of Graphql::Analyzer::Instrumentation
  end

  it "has a version number" do
    expect(Graphql::Analyzer::VERSION).not_to be nil
  end
end
