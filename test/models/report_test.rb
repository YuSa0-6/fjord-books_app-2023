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
end
