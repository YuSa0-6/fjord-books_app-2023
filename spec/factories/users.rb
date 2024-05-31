# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    password { 'password' }
  end

  trait :alice do
    name { 'Alice' }
    email { 'alice@example.com' }
  end

  trait :guest do
    name { '' }
    email { 'guest@example.com' }
    password { 'password' }
  end
end
