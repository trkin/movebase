require 'test_helper'

class RequirementTest < ActiveSupport::TestCase
  test 'valid fixture' do
    assert_valid_fixture requirements
  end
end
