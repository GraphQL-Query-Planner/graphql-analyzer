module Explainer
  class Parser
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
      root, keys, *values, benchmark = stripped_output
      fields = keys[1..-1].split('|').map(&:strip).map(&:downcase).map(&:to_sym)

      explained_queries = values.map do |value|
        parsed_value = value[1..-1].split("|").map(&:strip)
        transformed_values = fields.zip(parsed_value).to_h
        ExplainedQuery.new(transformed_values)
      end

      Result.new(root, explained_queries, benchmark)
    end

    def stripped_output
      @stripped_output ||= begin
        explain_output.split("\n").reject { |line| line =~ /^\+.*\+$/ }
      end
    end
  end
end

# Sample Output:

# EXPLAIN for: SELECT `posts`.* FROM `posts` WHERE `posts`.`user_id` = 871873205
# +----+-------------+-------+------------+------+------------------------+------+---------+------+------+----------+-------------+
# | id | select_type | table | partitions | type | possible_keys          | key  | key_len | ref  | rows | filtered | Extra       |
# +----+-------------+-------+------------+------+------------------------+------+---------+------+------+----------+-------------+
# |  1 | SIMPLE      | posts | NULL       | ALL  | index_posts_on_user_id | NULL | NULL    | NULL |    5 |     60.0 | Using where |
# +----+-------------+-------+------------+------+------------------------+------+---------+------+------+----------+-------------+
