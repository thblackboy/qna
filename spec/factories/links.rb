FactoryBot.define do
  factory :link do
    name { "Google" }
    url { "https://google.com" }
    association :linkable
  end
end
