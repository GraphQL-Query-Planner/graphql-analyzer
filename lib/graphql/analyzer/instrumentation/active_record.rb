module GraphQL
  class Analyzer
    module Instrumentation
      class ActiveRecord < Base
        private

        def resolve_proc(type, field, method)
          ->(obj, args, ctx) do
            result = nil
            queries = ::ActiveRecord::Base.collecting_queries_for_explain do
              result = field.public_send(method).call(obj, args, ctx)
              if result.respond_to?(:to_a)
                result.to_a
              end
            end

            if queries.any?
              explain_output = ::ActiveRecord::Base.exec_explain(queries)
              parsed_output = parser.parse(explain_output)

              # TODO: Merge results when a field makes two types of queries
              # e.g. path: ['user', 'name'] makes a SQL and ES Query.
              ctx['graphql-analyzer']['resolvers'] << {
                'path' => ctx.path,
                'adapter' => adapter,
                'parentType' => type.name,
                'fieldName' => field.name,
                'returnType' => field.type.to_s,
                'details' => parsed_output
              }
            end

            result
          end
        end

        def parser
          raise NotImplementedError, "Please override in #{self.class.name}"
        end
      end
    end
  end
end
