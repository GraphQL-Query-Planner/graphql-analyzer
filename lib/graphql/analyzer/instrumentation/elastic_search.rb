module GraphQL
  class Analyzer
    module Instrumentation
      class ElasticSearch < Base
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

        private

        def resolve_proc(type, field, method)
          ->(obj, args, ctx) do
            result = field.public_send(method).call(obj, args, ctx)

            if @notifications.any?
              # TODO: Merge results when a field makes two types of queries
              # e.g. path: ['user', 'name'] makes a SQL and ES Query.
              ctx['graphql-analyzer']['resolvers'] << {
                'path' => ctx.path,
                'adapter' => adapter,
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

        def adapter
          @adapter ||= 'elasticsearch'
        end
      end
    end
  end
end
