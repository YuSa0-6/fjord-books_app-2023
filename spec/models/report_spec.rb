# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Report, type: :model do
  before do
    @alice_report = FactoryBot.build(:report, :created_alice)
    @guest_report = FactoryBot.build(:report, :created_guest)
    @alice = FactoryBot.build(:user, :alice)
    @guest = FactoryBot.build(:user, :guest)
  end

  describe 'editable?' do
    context 'when the report is created by the user' do
      it 'returns true' do
        expect(@alice_report.editable?(@alice_report.user)).to eq true
      end
    end
    context 'when the report is not created by the user' do
      it 'returns false' do
        expect(@alice_report.editable?(@guest)).to eq false
      end
    end
  end

  describe 'save mentions' do
    context 'when the content includes a report URI' do
      it 'matching references to and from' do
        @alice_report.content = "http://localhost:3000/reports/#{@guest_report.id}"
        expect().to eq @alice_report.mentioning_reports.count
      end
    end
    context 'when the content includes  multiple repots URIs' do
    end
  end
end
