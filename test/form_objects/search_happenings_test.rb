require 'test_helper'

class SearchHappeningsTest < ActiveSupport::TestCase
  test 'find kayaking happenings: regata, personal, quadrathlon' do
    kayaking = activities(:kayaking)
    results = SearchHappenings.new(activity_id: kayaking.id).results

    assert_includes results, happenings(:kayak_regata)
    assert_includes results, happenings(:personal_long_kayaking)
    assert_includes results, happenings(:quadrathlon_munich)
  end

  test 'find happening in 10km' do
  end

  test 'find happening this month' do
  end

  test 'find happening for terain stairs' do
  end

  test 'find kayaking discipline_happenings in 5000m length' do
  end

  test 'find kayaking discipline_happenings with recreational kayak equipment' do
    # should we show quadrathlon
  end
end
