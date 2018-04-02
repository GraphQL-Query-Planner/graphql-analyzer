SearchResultType = GraphQL::ObjectType.define do
  name 'SearchResultType'
  description 'A search result.'

  field :index, !types.String, resolve: -> (obj, _, _) { obj['_index'] }
  field :type, !types.String, resolve: -> (obj, _, _) { obj['_type'] }
  field :id, !types.String, resolve: -> (obj, _, _) { obj['_id'] }
  field :score, !types.Float, resolve: -> (obj, _, _) { obj['_score'] }

  field :record, !SearchRecordType, resolve: -> (obj, _, _) do
    obj['_type'].camelize.constantize.new(obj['_source'])
  end
end
