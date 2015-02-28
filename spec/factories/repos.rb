FactoryGirl.define do
  factory :repo do
    sequence(:name) { |n| "Test Repo #{n}" }
  end
end
