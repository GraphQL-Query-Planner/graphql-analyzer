FactoryBot.define do
  factory :user do
    first_name { 'Derek' }
    last_name { 'Stride' }
    email { 'derek@shopify.com' }

    trait :with_posts do
      posts { build_list :post, 3 }
    end
  end
end
