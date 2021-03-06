module GraphQL
  class Analyzer
    module Instrumentation
      class Sqlite3 < ActiveRecord
        private

        def parser
          Parser::Sqlite3
        end

        def adapter
          @adapter ||= 'sqlite3'
        end
      end
    end
  end
end
