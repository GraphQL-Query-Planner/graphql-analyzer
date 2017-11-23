CommentType = GraphQL::ObjectType.define do
  name 'Comment'
  description 'A comment a user left on some content.'

  implements GraphQL::Relay::Node.interface

  global_id_field :id

  field :body, !types.String
  field :author, !UserType
  field :content, !ContentType
end
