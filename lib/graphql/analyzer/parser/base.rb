module GraphQL
  class Analyzer
    module Parser
      class Base
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
          raise NotImplementedError, "Please override in #{self.class.name}"
        end
      end
    end
  end
end
