FactoryBot.define do
  factory :post do
    body 'Hello, World!'
    association :author, factory: :user
    association :receiver, factory: :user
  end
end
