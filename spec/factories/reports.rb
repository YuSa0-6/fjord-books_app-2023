# frozen_string_literal: true

FactoryBot.define do
  factory :report do
    sequence(:title) { |n| "title#{n}" }
    sequence(:content) { |n| "content#{n}" }
    created_at { Time.zone.now }
    association :user
  end
end
