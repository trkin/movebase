require 'test_helper'

class HappeningsControllerTest < ActionDispatch::IntegrationTest
  test 'index_for_activities blank' do
    get index_for_disciplines_happenings_path
    assert_response :success

    happening = happenings(:kayak_regata)
    assert_select 'td', happening.name
  end

  test 'index_for_activities running' do
    activity = activities(:running)
    get index_for_activities_happenings_path(activity_names: [activity.name])

    assert_select 'td', {text: happenings(:kayak_regata).name, count: 0}
  end

  test 'show' do
    happening = happenings(:kayak_regata)
    get happening_path(happening)
    assert_select 'dd', happening.name
  end

  test 'show without discipline' do
    happening = happenings(:kayaking_no_discipline)
    get happening_path(happening)
    assert_select 'dd', happening.name
  end
end
