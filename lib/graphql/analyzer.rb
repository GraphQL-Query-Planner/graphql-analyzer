require "graphql/analyzer/version"
require "graphql/analyzer/instrumentation"
require "graphql/analyzer/parser"
require "graphql/analyzer/result"
require "graphql/analyzer/explained_query"

module GraphQL
  class Analyzer
    def initialize(graphql_schema)
      @graphql_schema = graphql_schema
    end

    def execute(*args)
      instrumenter = Instrumentation.new
      result = schema(instrumenter).execute(*args)
      result['extensions'] ||= {}
      result['extensions']['graphql-analyzer'] = instrumenter
      result
    end

    private

    attr_reader :graphql_schema

    def schema(instrumenter)
      graphql_schema.redefine { instrument(:field, instrumenter) }
    end
  end
end
