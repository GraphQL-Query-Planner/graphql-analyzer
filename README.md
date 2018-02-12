# GraphQL::Analyzer

[![Build Status](https://travis-ci.org/GraphQL-Query-Planner/graphql-analyzer.svg?branch=master)](https://travis-ci.org/GraphQL-Query-Planner/graphql-analyzer)
[![Gem Version](https://badge.fury.io/rb/graphql-analyzer.svg)](https://rubygems.org/gems/graphql-analyzer)


GraphQL Analyzer is a [GraphQL](https://github.com/rmosolgo/graphql-ruby) extension for tracking datastore queries.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'graphql-analyzer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install graphql-analyzer

## Usage

Add an instance of GraphQL::Analyzer to your schema, instantiate it with a list of instrumentations to capture different datastore queries.

### Analyzer

Add 'GraphQL::Analyzer' to your schema:

```ruby
require 'graphql/analyzer'

Schema = GraphQL::Schema.define do
  query QueryType
  use(
      GraphQL::Analyzer.new(
        GraphQL::Analyzer::Instrumentation::Mysql.new,
        GraphQL::Analyzer::Instrumentation::Postgresql.new
      )
  )
end
```

### Response Format

The GraphQL specification allows servers to [include additional information as part of the response under an `extensions` key](https://facebook.github.io/graphql/#sec-Response-Format):

> The response map may also contain an entry with key `extensions`. This entry, if set, must have a map as its value. This entry is reserved for implementors to extend the protocol however they see fit, and hence there are no additional restrictions on its contents.

GraphQL Analyzer exposes datastore query data for an individual request under a `analyzer` key in `extensions`:

```json
{
  "data": <>,
  "errors": <>,
  "extensions": {
    "analyzer": {
      "version": 1,
      "execution": {
        "resolvers": [
          {
            "path": [
              "node"
            ],
            "adapter": "sqlite3",
            "parentType": "Query",
            "fieldName": "node",
            "returnType": "Node",
            "details": {
              "root": "EXPLAIN for: SELECT  \"users\".* FROM \"users\" WHERE \"users\".\"id\" = ? LIMIT ? [[\"id\", 7], [\"LIMIT\", 1]",
              "explained_queries": [
                {
                  "select_id": "0",
                  "order": "0",
                  "from": "0",
                  "details": "SEARCH TABLE users USING INTEGER PRIMARY KEY (rowid=?)"
                }
              ]
            }
          }
        ]
      }
    }
  }
}
```

### Instrumentation

There are some common instruments already implemented that should work right away.

- `Sqlite3`
- `Mysql`
- `Postgresql`

Check [`lib/graphql/analyzer/instrumentation`](https://github.com/GraphQL-Query-Planner/graphql-analyzer/tree/master/lib/graphql/analyzer/instrumentation) for the full list.

To write your own custom instrumentation, your object needs to respond to `#instrument(type, field)` and return a lambda that accepts three parameters, `object`, `arguments`, and `context`, and returns the original field value. It should also add any queries captured to the `context`.

```ruby
module GraphQL
  class Analyzer
    module Instrumentation
      class MyCustomInstrumentation < Base
        def instrument(type, field)
          ->(obj, args, ctx) do
            ### OMITTED ###
              ctx['graphql-analyzer']['resolvers'] << {
                'adapter' => 'My Custom Adapter',
                'path' => ctx.path,
                'parentType' => type.name,
                'fieldName' => field.name,
                'returnType' => field.type.to_s,
                'details' => 'My Adapter Specific Information'
              }
              ### OMITTED ###
          end
        end
      end
    end
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/GraphQL-Query-Planner/graphql-analyzer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
