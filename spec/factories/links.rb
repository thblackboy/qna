FactoryBot.define do
  factory :link do
    name { "Google" }
    url { "https://google.com" }
    association :linkable
    trait :gist do
      url { "https://gist.github.com/thblackboy/2055d08ffa7a21b1e0d432f485ebfa82" }
    end
  end
end
