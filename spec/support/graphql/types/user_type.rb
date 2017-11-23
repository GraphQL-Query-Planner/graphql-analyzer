UserType = GraphQL::ObjectType.define do
  name 'User'
  description 'A user'

  implements GraphQL::Relay::Node.interface

  global_id_field :id

  field :first_name, !types.String
  field :last_name, types.String
  field :email, !types.String

  field :posts, types[PostType]
  field :wall, types[PostType]
  field :comments, types[CommentType]
end
