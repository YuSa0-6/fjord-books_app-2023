# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test '#editable?' do
    user = users(:alice)
    report = user.reports.new(reports(:report_alice).attributes)
    assert_equal true, report.editable?(user)
  end

  test '#created_on' do
    report = Report.new(created_at: Time.zone.local(2021, 1, 1, 12, 0, 0))
    assert_equal Date.new(2021, 1, 1), report.created_on
  end
end
