require 'spec_helper'

describe GraphQL::Analyzer::ActiveRecordInstrumentation do
  let(:field) do
    field = GraphQL::Field.new
    field.resolve = ->(obj, args, ctx) { User.first }
    field
  end
  let(:instrumentation) { GraphQL::Analyzer::ActiveRecordInstrumentation.new }
  let(:instrumented_proc) { instrumentation.instrument(OpenStruct.new(name: 'TypeName'), field) }
  let(:mock_ctx) { MockContext.new(path: ['user']) }

  context '#instrument' do
    it 'should return a graphql field' do
      expect(instrumented_proc).to be_kind_of Proc
    end

    it 'should return the same value as the uninstrumented field' do
      expected = field.resolve(nil, nil, mock_ctx)
      expect(expected).to eq instrumented_proc.call(nil, nil, mock_ctx)
    end

    it 'should capture queries made when resolved in the ctx' do
      expect(mock_ctx['graphql-analyzer']['resolvers']).to be_empty
      instrumented_proc.call(nil, nil, mock_ctx)
      expect(mock_ctx['graphql-analyzer']['resolvers']).not_to be_empty
    end
  end
end
