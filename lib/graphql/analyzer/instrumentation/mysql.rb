module GraphQL
  class Analyzer
    module Instrumentation
      class Mysql < Base
        private

        def parser
          Parser::Mysql
        end
      end
    end
  end
end
