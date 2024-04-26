# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test '#editable?' do
    user = User.new(email: 'test@sample.com', password: 'password')
    report = user.reports.new(title: 'title', content: 'content')
    assert_equal true, report.editable?(user)
  end
end
