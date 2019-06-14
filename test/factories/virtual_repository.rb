FactoryBot.define do
  factory :virtual_repository do
    sequence(:title) {|n| "Virtual Repository #{n}"}
    repository
  end
end