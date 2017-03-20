FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "test_user_#{n}@example.com" }
    password "pass123"
  end
end
