AppSchema = GraphQL::Schema.define do
  query QueryType

  orphan_types [UserType, PostType, ContentType, CommentType]

  id_from_object ->(object, _, _) { object.to_global_id.to_s }
  object_from_id -> (id, _ctx) { ActiveRecordResolver.call(nil, { id: id }, nil) }
  resolve_type -> (type, obj, _ctx) do
    if type.respond_to?(:possible_types)
      type.possible_types.detect { |t| t.name == obj.class.name }
    else
      "#{obj.class}Type".constantize
    end
  end
end
