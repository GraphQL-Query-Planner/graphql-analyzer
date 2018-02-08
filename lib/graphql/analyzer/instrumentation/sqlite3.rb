module GraphQL
  class Analyzer
    module Instrumentation
      class Sqlite3 < Base
        private

        def parser
          Parser::Sqlite3
        end
      end
    end
  end
end