FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "Test User #{n}" }

    uid      Faker::Number.number(7)
    username { "#{name}".delete(' ') }
  end
end
