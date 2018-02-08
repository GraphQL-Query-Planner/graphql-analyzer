module GraphQL
  class Analyzer
    class Parser
      class << self
        def parse(explain_output)
          new(explain_output).result
        end
      end

      attr_reader :explain_output

      def initialize(explain_output)
        @explain_output = explain_output
      end

      def result
        @result ||= parse
      end

      private

      def parse
        root, keys, *values, benchmark = stripped_output
        fields = keys[1..-1].split('|').map(&:strip).map(&:downcase)

        explained_queries = values.map do |value|
          parsed_value = value[1..-1].split("|").map(&:strip)
          fields.zip(parsed_value).to_h
        end

        Result.new(root, explained_queries, benchmark)
      end

      def stripped_output
        @stripped_output ||= begin
          explain_output.split("\n").reject { |line| line =~ /^\+.*\+$/ }
        end
      end
    end
  end
end
