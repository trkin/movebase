require 'test_helper'

class LinkTest < ActiveSupport::TestCase
  test 'valid fixture' do
    assert_valid_fixture links
  end
end
