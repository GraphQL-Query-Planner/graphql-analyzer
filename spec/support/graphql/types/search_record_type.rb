SearchRecordType = GraphQL::UnionType.define do
  name 'SearchResultUnionType'
  description 'A searchable type.'
  possible_types [PostType, CommentType]
end
