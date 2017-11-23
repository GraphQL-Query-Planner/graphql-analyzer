module Explainer
  class ExplainedQuery
    FIELDS = %i(id select_type table partitions type possible_keys key key_len ref rows filtered extra).freeze
    NULL = 'NULL'.freeze

    FIELDS.each do |field|
      define_method(field) do
        explained_query[field]
      end
    end

    def initialize(explained_query)
      validate!(explained_query)
      @explained_query = explained_query
    end

    def indexed?
      type == 'ref' && key != NULL
    end

    def to_s
      "#<#{self.class.name}\n" +
      explained_query.map do |field, result|
        "@#{field}=\"#{result}\""
      end.join("\n") +
      ">"
    end

    def to_h
      explained_query.to_h
    end

    # the console will hide part of the data because the string is so long, so I filtered out some fields
    def inspect
      to_s.split("\n").reject { |line| line =~ /@id|@key_len|@rows|@filtered|@partitions/ }.join("\n")
    end

    private

    attr_reader :explained_query

    def validate!(explained_query)
      return if explained_query.keys == FIELDS
      return if explained_query.keys == FIELDS - %i(partitions filtered) # CI (MySQL 5.6?)
      raise "Explain fields not equal\nExpected: #{FIELDS}\nGot: #{explained_query.keys}"
    end
  end
end
