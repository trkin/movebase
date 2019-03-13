require 'test_helper'

class ClubTest < ActiveSupport::TestCase
  test 'valid fixture' do
    assert_valid_fixture clubs
  end
end
