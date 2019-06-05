require 'test_helper'

class SearchHappeningsTest < ActiveSupport::TestCase
  test '#all_cities' do
    search_happenings = SearchHappenings.new

    assert search_happenings.all_cities.index(venues(:novi_sad)) < search_happenings.all_cities.index(venues(:beograd))
  end

  test 'find kayaking happenings: regata, personal, quadrathlon' do
    results = SearchHappenings.new(activity_id: activities(:kayaking).id).results

    assert_includes results, happenings(:kayak_regata)
    assert_includes results, happenings(:personal_long_kayaking)
    assert_includes results, happenings(:quadrathlon_munich)
  end

  test 'find happening in 10km' do
    novi_sad = venues(:novi_sad)
    results = SearchHappenings.new(venue_id: novi_sad, activity_id: activities(:kayaking).id).results

    assert_includes results, happenings(:kayak_regata)
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
