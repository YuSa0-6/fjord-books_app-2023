# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test '#editable? with same user' do
    user = users(:alice)
    report = reports(:report_alice)
    assert_equal true, report.editable?(user)
  end

  test '#editable? with other user' do
    user = users(:guest)
    report = reports(:report_alice)
    assert_equal false, report.editable?(user)
  end

  test '#created_on' do
    report = Report.new(created_at: Time.zone.local(2021, 1, 1, 12, 0, 0))
    assert_equal Date.new(2021, 1, 1), report.created_on
  end
  test '#save_mentions with mentioning_reports' do
    report = reports(:report_alice)
    created_report = Report.create!(user: users(:alice), title: 'title', content: "http://localhost:3000/reports/#{report.id}")
    assert_equal report.id, created_report.mentioning_reports.first.id
  end

  test '#save_mentions with mentioned_reports' do
    report = reports(:report_alice)
    created_report = Report.create!(user: users(:alice), title: 'title', content: "http://localhost:3000/reports/#{report.id}")
    assert_equal created_report.id, report.mentioned_reports.first.id
  end

  test '#multiple save_mentions' do
    Report.create!(user: users(:guest), title: 'title', content: "http://localhost:3000/reports/#{reports(:report_alice).id}")
    Report.create!(user: users(:alice), title: 'title', content: "http://localhost:3000/reports/#{reports(:report_alice).id}")
    assert_equal 2, reports(:report_alice).mentioned_reports.count
  end

  test '#save_mentions with invalid URL' do
    created_report = Report.create!(user: users(:alice), title: 'title', content: 'http://localhost:3000/reports/xxxx')
    assert_equal 0, created_report.mentioning_reports.count
  end

  test '#delete_mentions' do
    report = Report.create!(user: users(:alice), title: 'title', content: "http://localhost:3000/reports/#{reports(:report_alice).id}")
    report.destroy
    assert_equal 0, reports(:report_alice).mentioned_reports.count
  end
  test '#update_mentions' do
    report = Report.create!(user: users(:alice), title: 'title', content: "http://localhost:3000/reports/#{reports(:report_alice).id}")
    report.update!(title: 'title', content: "http://localhost:3000/reports/#{reports(:report_guest).id}")
    assert_equal report.id, reports(:report_guest).mentioned_reports.first.id
  end
  test '#update_mentions with multiple URLs' do
    report = Report.create!(user: users(:alice), title: 'title', content: "http://localhost:3000/reports/#{reports(:report_alice).id}")
    report.update!(title: 'title', content: "http://localhost:3000/reports/#{reports(:report_guest).id} http://localhost:3000/reports/#{reports(:report_alice2).id}")
    assert_equal report.id, reports(:report_guest).mentioned_reports.first.id
  end
  test '#update_mentions with deleted URL' do
    report = Report.create!(user: users(:alice), title: 'title', content: "http://localhost:3000/reports/#{reports(:report_alice).id}")
    report.update!(title: 'title', content: 'deleted links')
    assert_equal 0, reports(:report_alice).mentioned_reports.count
  end
end
