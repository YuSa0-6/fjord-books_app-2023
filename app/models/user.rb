# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :avatar
  scope :with_eager_loaded_avater, -> { eager_load(avatar_attachment: :avatar) }
end
