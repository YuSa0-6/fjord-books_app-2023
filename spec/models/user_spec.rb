# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'name_or_email' do
    context 'ユーザーに名前がある時' do
      it 'nameを返す' do
        user = FactoryBot.build(:user)
        expect(user.name_or_email).to eq user.name
      end
    end
    context 'ユーザーに名前がない時' do
      it 'emailを返す' do
        no_name_user = FactoryBot.build(:user, :no_name_user)
        expect(no_name_user.name_or_email).to eq no_name_user.email
      end
    end
  end
end
