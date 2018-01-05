require 'spec_helper'

describe GraphQL::Analyzer do
  let(:user) { create(:user, :with_posts) }
  let(:query_string) { %|{ node(id: "#{user.to_global_id}") { id } }| }
  let(:schema) { AppSchema.redefine { use(GraphQL::Analyzer.new([])) } }
  let(:result) do
    res = schema.execute(query_string, context: {}, variables: {})
    pp res if res.key?('errors')
    res
  end

  it 'should work' do
    expect(result['extensions']['analyzer']).to be_kind_of Hash
  end

  it "has a version number" do
    expect(GraphQL::Analyzer::VERSION).not_to be nil
  end
end
