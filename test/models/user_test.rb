# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test '#name_or_email' do
    user = User.new(email: 'test9@sample.com', name: '')

    assert_equal 'test9@sample.com', user.name_or_email
  end
end
