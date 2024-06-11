# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:id) { |n| n }
    sequence(:name) { |n| "user#{n}" }
    sequence(:email) { |n| "sample#{n}@example.com" }
    password { 'password' }
  end

  trait :no_name_user do
    name { '' }
  end
end
