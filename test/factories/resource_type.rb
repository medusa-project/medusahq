FactoryBot.define do
  factory :resource_type do
    sequence(:name) {|n| "Resource Type #{n}"}
  end
end