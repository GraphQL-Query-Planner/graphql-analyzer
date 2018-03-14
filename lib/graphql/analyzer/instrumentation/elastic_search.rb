module GraphQL
  class Analyzer
    module Instrumentation
      class ElasticSearch
        def initialize
          @notifications = []
          ActiveSupport::Notifications.subscribe('search.elasticsearch') do |name, start, finish, id, payload|
            @notifications << {
              name: name,
              start: start,
              finish: finish,
              id: id,
              payload: payload
            }
          end
        end

        def instrument(type, field)
          ->(obj, args, ctx) do
            result = field.resolve_proc.call(obj, args, ctx)

            if @notifications.any?
              # TODO: Merge results when a field makes two types of queries
              # e.g. path: ['user', 'name'] makes a SQL and ES Query.
              ctx['graphql-analyzer']['resolvers'] << {
                'path' => ctx.path,
                'adapter' => 'elasticsearch',
                'parentType' => type.name,
                'fieldName' => field.name,
                'returnType' => field.type.to_s,
                'details' => @notifications
              }

              @notifications = []
            end

            result
          end
        end
      end
    end
  end
end
