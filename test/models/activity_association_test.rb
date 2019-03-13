require 'test_helper'

class ActivityAssociationTest < ActiveSupport::TestCase
  test 'valid fixture' do
    assert_valid_fixture activity_associations
  end

  test 'consists_of_activities' do
    results = activities(:quadrathlon).consists_of_activities

    assert_includes results, activities(:kayaking)
    assert_includes results, activities(:cycling)
    assert_includes results, activities(:swimming)
    assert_includes results, activities(:walking_and_running)
  end

  test 'used_in_activities' do
    results = activities(:kayaking).used_in_activities

    assert_includes results, activities(:kayak_duathlon)
    assert_includes results, activities(:quadrathlon)
    assert_not_includes results, activities(:kayaking)
  end

  test 'self_and_used_in_activities' do
    results = activities(:kayaking).self_and_used_in_activities

    assert_includes results, activities(:kayaking)
  end
end
