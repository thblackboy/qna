FactoryBot.define do
  factory :answer do
    body { 'MyText' }
    question
    author_id { User.first }

    trait :invalid do
      body { nil }
    end
  end
end
