require 'test_helper'

class TodoTest < ActiveSupport::TestCase
  test 'valid fixture' do
    assert_valid_fixture todos
  end
end
