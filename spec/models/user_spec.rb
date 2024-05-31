# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @alice = FactoryBot.build(:user, :alice)
    @guest = FactoryBot.build(:user, :guest)
  end

  describe 'name_or_email' do
    context 'name exists' do
      it 'returns name' do
        expect(@alice.name) == @alice.name_or_email
      end
    end
    context 'name does not exists' do
      it 'returns email' do
        expect(@guest.email) == @guest.name_or_email
      end
    end
  end
end
