require 'test_helper'

class LeagueTest < ActiveSupport::TestCase
  test 'valid fixture' do
    assert_valid_fixture leagues
  end
end
