require 'test_helper'

class HappeningsForActivityNamesDatatableTest < ActiveSupport::TestCase
  def sample_view_params(params = {})
    OpenStruct.new(
      params: params
    )
  end

  test 'find kayaking happenings: regatta, personal' do
    results = HappeningsForActivityNamesDatatable.new(sample_view_params(activity_names: [activities(:kayaking).name])).all_items

    assert_includes results, happenings(:kayak_regatta)
    assert_includes results, happenings(:personal_long_kayaking)
    assert_includes results, happenings(:quadrathlon_munich)
    refute_includes results, happenings(:half_marathon)
  end

  # test 'find happening in 10km' do
  #   novi_sad = venues(:novi_sad)
  #   results = SearchHappenings.new(venue_id: novi_sad, activity_id: activities(:kayaking).id).results

  #   assert_includes results, happenings(:kayak_regatta)
  # end

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
