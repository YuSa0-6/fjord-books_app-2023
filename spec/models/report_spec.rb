# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Report, type: :model do
  before do
    @report = FactoryBot.create(:report)
    @other_report = FactoryBot.create(:report)
  end
  describe 'editable?の関数において' do
    context '投稿者本人のとき' do
      it 'trueを返す' do
        report = @report
        expect(report.editable?(report.user)).to eq true
      end
    end
    context '投稿者以外の時' do
      it 'falseを返す' do
        report = @report
        expect(report.editable?(FactoryBot.build(:user))).to eq false
      end
    end
  end

  describe 'created_onの関数において' do
    context '日報を作成する場合' do
      it '日報の作成日時を返す' do
        report = FactoryBot.build(:report, created_at: Time.zone.local(2021, 1, 1, 12, 0, 0))
        expect(report.created_on).to eq Date.new(2021, 1, 1)
      end
    end
  end

  describe 'save_mentionsの関数において' do
    context '日報の言及先が１つの場合' do
      context '言及先を１つ作成する' do
        it '言及先が１つある' do
          report = @report
          mentioning_report = FactoryBot.create(:report, content: "http://localhost:3000/reports/#{report.id}")
          expect(report.id).to eq mentioning_report.mentioning_reports.first.id
        end
      end
      context '言及先を更新する時' do
        it '更新した言及元がある' do
          report = @report
          other_report = @other_report
          mentioning_report = FactoryBot.create(:report, content: "http://localhost:3000/reports/#{report.id}")
          mentioning_report.update!(content: "http://localhost:3000/reports/#{other_report.id}")
          expect(mentioning_report.id).to eq other_report.mentioned_reports.first.id
        end
      end
      context '言及先を削除する時' do
        it '言及先がない' do
          report = @report
          mentioning_report = FactoryBot.create(:report, content: "http://localhost:3000/reports/#{report.id}")
          report.destroy
          expect(mentioning_report.mentioning_reports.count).to eq 0
        end
      end
    end
    context '日報の言及先が2つの場合' do
      context '言及先を2つ作成する' do
        it '言及先が２つある' do
          report = @report
          other_report = @other_report
          mentioning_report = FactoryBot.create(:report, content: "http://localhost:3000/reports/#{report.id} http://localhost:3000/reports/#{other_report.id}")
          expect(2).to eq mentioning_report.mentioning_reports.count
        end
      end
      context '言及先を１つ更新する時' do
        it '更新した言及先がある' do
          report = @report
          other_report = @other_report
          another_report = FactoryBot.create(:report)
          mentioning_report = FactoryBot.create(:report, content: "http://localhost:3000/reports/#{report.id} http://localhost:3000/reports/#{other_report.id}")
          mentioning_report.update!(content: "http://localhost:3000/reports/#{report.id} http://localhost:3000/reports/#{another_report.id}")
          expect(another_report.mentioned_reports.first.id).to eq mentioning_report.id
        end
        it '更新していない言及先がそのまま維持される' do
          report = @report
          other_report = @other_report
          another_report = FactoryBot.create(:report)
          mentioning_report = FactoryBot.create(:report, content: "http://localhost:3000/reports/#{report.id} http://localhost:3000/reports/#{other_report.id}")
          mentioning_report.update!(content: "http://localhost:3000/reports/#{report.id} http://localhost:3000/reports/#{another_report.id}")
          expect(report.mentioned_reports.first.id).to eq mentioning_report.id
        end
      end
      context '言及先をすべて削除する時' do
        it '言及先がない' do
          report = @report
          other_report = @other_report
          mentioning_report = FactoryBot.create(:report, content: "http://localhost:3000/reports/#{report.id} http://localhost:3000/reports/#{other_report.id}")
          report.destroy
          other_report.destroy
          expect(mentioning_report.mentioning_reports.count).to eq 0
        end
      end
    end
  end
end
