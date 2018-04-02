class Post < ApplicationRecord
  include Elasticsearch::Model

  belongs_to :author, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  has_many :comments, as: :content
end
