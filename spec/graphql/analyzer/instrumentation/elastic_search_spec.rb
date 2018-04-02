describe "graphql fields backed by ElasticSearch" do
  let(:instrumentation) { GraphQL::Analyzer::Instrumentation::ElasticSearch.new }
  let!(:comment) { create(:comment, body: "Hello, World!", content: post) }
  let!(:post) { create(:post, body: "Hello, World!") }
  let(:query_string) do 
    %|{ 
      search(query: "Hello") {
        id
        score
        index
        type
        record {
          __typename
        }
      }  
    }|
  end

  let(:schema) do
    analyzer = GraphQL::Analyzer.new([instrumentation])
    AppSchema.redefine { use(analyzer) }
  end

  let(:result) do
    res = schema.execute(query_string, context: {}, variables: {})
    pp res if res.key?('errors')
    res
  end  

  it 'captures es queries' do
    binding.pry
    expected = result.dig('extensions', 'analzyer', 'execution', 'resolvers')
    expect(expected).not_to be_empty
  end

  it 'the adapter is elasticsearch' do
    expected = result.dig('extensions', 'analzyer', 'execution', 'resolvers', 0, 'adapter')
    expect(expected).to eq 'elasticsearch'
  end

  it 'provides details about the query' do
    expected = result.dig('extensions', 'analyzer', 'execution', 'resolvers', 0, 'details')
    expect(expected).not_to be_nil
  end
end