FactoryBot.define do
  factory :user do
    name { "テスト" }
    email { "test100@test.com" }
    password { "1234" }
  end
end