module GraphQL
  class Analyzer
    module Instrumentation
      class Mysql < ActiveRecord
        private

        def parser
          Parser::Mysql
        end

        def adapter
          @adapter ||= 'mysql'
        end
      end
    end
  end
end
