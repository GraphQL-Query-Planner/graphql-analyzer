require "graphql"
require "graphql/analyzer/version"
require "graphql/analyzer/instrumentation/mysql"
require "graphql/analyzer/parser/mysql"
require "graphql/analyzer/result"
require "graphql/analyzer/explained_query"

module GraphQL
  class Analyzer
    attr_reader :instruments
    private :instruments

    def initialize(instruments)
      @instruments = instruments
    end

    def use(schema_definition)
      schema_definition.instrument(:query, self)
      schema_definition.instrument(:field, self)
    end

    def before_query(query)
      query.context['graphql-analyzer'] = { 'resolvers' => [] }
    end

    def after_query(query)
      result = query.result

      result["extensions"] ||= {}
      result["extensions"]["analyzer"] = {
        "version" => 1,
        "execution" => {
          "resolvers" => query.context['graphql-analyzer']['resolvers']
        }
      }
    end

    def instrument(type, field)
      instruments.reduce(field) do |field, instrumentation|
        field.redefine { resolve(instrumentation.instrument(type, field)) }
      end
    end
  end
end


