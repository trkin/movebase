require 'test_helper'

class VenueTest < ActiveSupport::TestCase
  test 'valid fixture' do
    assert_valid_fixture venues
  end
end
