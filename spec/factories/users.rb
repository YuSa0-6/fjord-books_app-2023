# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'Alice' }
    email { 'alice@example.com' }
    password { 'password' }
  end
end
