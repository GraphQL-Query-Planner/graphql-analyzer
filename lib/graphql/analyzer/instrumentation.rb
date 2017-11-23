module Graphql
  class Analyzer
    class Instrumentation
      attr_reader :results

      def initialize
        @results = []
      end

      def instrument(_type, field)
        new_resolve_proc = analyze_resolve_proc(_type, field)
        field.redefine do
          resolve(new_resolve_proc)
        end
      end

      def to_h
        {
          execution: {
            resolvers: @results.map(&:to_h)
          }
        }
      end

      def to_json(options = nil)
        to_h
      end
      alias_method :as_json, :to_json

      private

      def analyze_resolve_proc(_type, field)
        -> (obj, args, ctx) do
          queries = ActiveRecord::Base.collecting_queries_for_explain do
            records = field.resolve_proc.call(obj, args, ctx)
            records.to_a if records.respond_to?(:to_a)
          end

          if queries.any?
            explain_output = ActiveRecord::Base.exec_explain(queries)
            result = Explainer::Parser.parse(explain_output)
            result.path = ctx.path
            results << result
          end

          field.resolve_proc.call(obj, args, ctx)
        end
      end
    end
  end
end
