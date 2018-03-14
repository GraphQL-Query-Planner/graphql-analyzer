module GraphQL
  class Analyzer
    module Parser
      class Postgresql < Base
        private

        def parse
          root, *values, _ = explain_output.split("\n").reject { |line| line =~ /(QUERY\ PLAN)|-{5,}/ }
          [Result.new(root, [values.join("\n")])]
        end
      end
    end
  end
end
