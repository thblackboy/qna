FactoryBot.define do
  sequence :title do |n|
    "Question title #{n}"
  end
  factory :question do
    title
    body { 'Question text' }
    association :author, factory: :user
    trait :invalid do
      title { nil }
    end
    trait :with_file do
      after(:build) do |question|
        question.files.attach(io: File.open('spec/image.png'), filename: 'image.png', content_type: 'image/png')
      end
    end
  end
end
