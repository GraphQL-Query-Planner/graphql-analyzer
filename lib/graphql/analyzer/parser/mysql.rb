module GraphQL
  class Analyzer
    module Parser
      class Mysql < Base
        private

        def parse
          explained_output_by_query = explain_output.split(/^EXPLAIN.*$/).map(&:chomp).reject(&:empty?)
          queries = explain_output.split("\n").select { |l| l =~ /^EXPLAIN.*$/ }
          
          results = []
          queries.each.with_index do |query, i|
            keys, *values, _ = explained_output_by_query[i]
              .split("\n")
              .map(&:chomp)
              .reject { |line| line.empty? || line =~ /^\+.*\+$/ }
            fields = keys[1..-1].split('|').map(&:strip).map(&:downcase)

            explained_queries = values.map do |value|
              parsed_value = value[1..-1].split("|").map(&:strip)
              fields.zip(parsed_value).to_h
            end

            results << Result.new(query, explained_queries)
          end
          results
        end
      end
    end
  end
end
