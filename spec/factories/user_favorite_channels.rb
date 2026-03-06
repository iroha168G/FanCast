FactoryBot.define do
  factory :user_favorite_channel do
    association :user
    association :channel
  end
end
