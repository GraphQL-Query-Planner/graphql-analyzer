module GraphQL
  class Analyzer
    module Instrumentation
      class Postgresql < ActiveRecord
        private

        def parser
          Parser::Postgresql
        end

        def adapter
          @adapter ||= 'postgresql'
        end
      end
    end
  end
end
