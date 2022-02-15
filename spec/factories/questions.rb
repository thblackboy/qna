FactoryBot.define do
  sequence :title do |n|
    "Question title #{n}"
  end
  
  factory :question do
    title
    body { 'Question text' }

    trait :invalid do
      title { nil }
    end
  end
end
