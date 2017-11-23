class User < ApplicationRecord
  has_many :posts, foreign_key: :author_id, class_name: 'Post'
  has_many :wall, foreign_key: :receiver_id, class_name: 'Post'

  has_many :comments, foreign_key: :author_id
end
