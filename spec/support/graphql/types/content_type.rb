ContentType = GraphQL::UnionType.define do
  name 'Content'
  description 'Some form of content (e.g. photo or post).'
  possible_types [PostType, CommentType]
end
