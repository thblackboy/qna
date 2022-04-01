FactoryBot.define do
  factory :vote do
    association :voter, factory: :user
    association :votable
    value { -1 }
    trait :up do
      value { 1 }
    end
  end
end
