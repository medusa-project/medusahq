FactoryBot.define do
  factory :virtual_repository do
    title {|n| "Virtual Repository #{n}"}
    repository
  end
end