require 'test_helper'

class ClubUserTest < ActiveSupport::TestCase
  test 'valid fixture' do
    assert_valid_fixture club_users
  end
end
