require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'valid fixture' do
    assert_valid_fixture activities
  end
end
