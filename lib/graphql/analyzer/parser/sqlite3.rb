module GraphQL
  class Analyzer
    module Parser
      class Sqlite3 < Base
        FIELDS = %w(select_id order from details).freeze

        private

        def parse
          root, *values = explain_output.split("\n")
          explained_queries = values.map { |value| FIELDS.zip(value.split("|").map(&:strip)).to_h }
          Result.new(root, explained_queries)
        end
      end
    end
  end
end
