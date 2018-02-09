module GraphQL
  class Analyzer
    module Parser
      class Mysql < Base
        private

        def parse
          root, keys, *values, _ = explain_output.split("\n").reject { |line| line =~ /^\+.*\+$/ }
          fields = keys[1..-1].split('|').map(&:strip).map(&:downcase)

          explained_queries = values.map do |value|
            parsed_value = value[1..-1].split("|").map(&:strip)
            fields.zip(parsed_value).to_h
          end

          Result.new(root, explained_queries)
        end
      end
    end
  end
end
