FactoryBot.define do
  factory :user do
    sequence(:uid) {|n| "user_#{n}@example.com"}
    sequence(:email) {|n| "user_#{n}@example.com"}
  end
end