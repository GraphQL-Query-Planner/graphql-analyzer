module GraphQL
  class Analyzer
    class Result
      attr_accessor :path
      attr_reader :root, :explained_queries
      alias_method :queries, :explained_queries

      def initialize(root, explained_queries)
        @root = root
        @explained_queries = explained_queries
      end

      def to_h
        {
          query: root,
          details: explained_queries,
          path: path
        }
      end
    end
  end
end
