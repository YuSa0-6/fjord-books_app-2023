# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test '#name_or_email with is name ' do
    user = users(:alice)

    assert_equal 'alice', user.name_or_email
  end

  test '#name_or_email with no name' do
    user = users(:guest)
    assert_equal 'guest@sample.com', user.name_or_email
  end
end
