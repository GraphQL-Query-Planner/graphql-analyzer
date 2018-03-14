module GraphQL
  class Analyzer
    module Instrumentation
      class Base
        def instrument(type, field)
          resolve_proc(type, field, :resolve_proc)
        end

        def instrument_lazy(type, field)
          resolve_proc(type, field, :lazy_resolve_proc)
        end

        private

        def resolve_proc(type, field, method)
          raise NotImplementedError, "Please override in #{self.class.name}"
        end

        def adapter
          raise NotImplementedError, "Please override in #{self.class.name}"
        end
      end
    end
  end
end
