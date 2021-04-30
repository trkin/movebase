require 'test_helper'

class UserRoleTest < ActiveSupport::TestCase
  test 'valid fixture' do
    assert_valid_fixture user_roles
  end
end
