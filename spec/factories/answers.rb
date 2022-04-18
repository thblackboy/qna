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
    trait :with_file do
      after(:build) do |answer|
        answer.files.attach(io: File.open('spec/image.png'), filename: 'image.png', content_type: 'image/png')
      end
    end
  end
end
