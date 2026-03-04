FactoryBot.define do
  factory :channel do
    platform { "youtube" }
    name { "テスト" }
    channel_identifier { "test_id" }
    thumbnail_url { "https://example.com/thumb.png"}
  end
end