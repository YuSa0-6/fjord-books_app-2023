# frozen_string_literal: true

FactoryBot.define do
  factory :report do
    title { 'title' }
    content { 'content' }
  end

  trait :created_guest do
    user { FactoryBot.create(:user, :guest) }
  end

  trait :created_alice do
    user { FactoryBot.create(:user, :alice) }
  end
end
