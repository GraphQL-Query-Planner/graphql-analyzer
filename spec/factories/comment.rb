FactoryBot.define do
  factory :comment do
    body { 'Hello, World!' }
    association :author, factory: :user

    factory :post_comment do
      association :content, factory: :post
    end
  end
end
