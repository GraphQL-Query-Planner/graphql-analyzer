class Comment < ApplicationRecord
  include Elasticsearch::Model

  belongs_to :author, class_name: 'User'
  belongs_to :content, polymorphic: true
end
