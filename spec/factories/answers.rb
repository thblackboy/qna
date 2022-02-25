FactoryBot.define do
  sequence :body do |n|
    "answer body #{n}"
  end
  factory :answer do
    body
    association :question
    association :author, factory: :user

    trait :invalid do
      body { nil }
    end
  end
end
