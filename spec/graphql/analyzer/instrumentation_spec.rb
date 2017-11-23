require 'spec_helper'

describe GraphQL::Analyzer::Instrumentation do
  let(:field) do
    field = GraphQL::Field.new
    field.resolve = ->(obj, args, ctx) { User.first }
    field
  end
  let(:instrumenter) { GraphQL::Analyzer::Instrumentation.new }
  let(:instrumented_field) { instrumenter.instrument(nil, field) }
  let(:mock_ctx) { OpenStruct.new(path: ['user']) }

  context '#instrument' do
    it 'should return a graphql field' do
      expect(instrumented_field).to be_kind_of GraphQL::Field
    end

    it 'should return the same value as the uninstrumented field' do
      expected = field.resolve(nil, nil, mock_ctx)
      expect(expected).to eq instrumented_field.resolve(nil, nil, mock_ctx)
    end

    it 'should capture queries made when resolved' do
      instrumented_field.resolve(nil, nil, mock_ctx)
      expect(instrumenter.results).not_to be_empty
    end
  end
end
