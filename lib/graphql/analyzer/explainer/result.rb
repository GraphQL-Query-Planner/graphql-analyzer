module Explainer
  class Result
    FIELDS = %i(id select_type table partitions type possible_keys key key_len ref  rows filtered extra).freeze

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
        explained_queries: explained_queries.map(&:to_h),
        path: path
      }
    end
  end
end
