FactoryBot.define do
  factory :comment do
    body { 'comment body' }
    association :commentable
    association :author, factory: :user
  end
end
