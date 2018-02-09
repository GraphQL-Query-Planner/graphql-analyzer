module GraphQL
  class Analyzer
    class Result
      attr_accessor :path
      attr_reader :root, :explained_queries, :benchmark
      alias_method :queries, :explained_queries

      def initialize(root, explained_queries, benchmark)
        @root = root
        @explained_queries = explained_queries
        @benchmark = benchmark
      end

      def to_h
        {
          query: root,
          benchmark: benchmark,
          details: explained_queries,
          path: path
        }
      end
    end
  end
end
