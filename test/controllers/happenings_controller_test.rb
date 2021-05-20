require 'test_helper'

class HappeningsControllerTest < ActionDispatch::IntegrationTest
  test 'index discipline_ids blank' do
    get happenings_path
    assert_response :success

    happening = happenings(:kayak_regatta)
    assert_select 'td', happening.name
  end

  test 'index triathlon' do
    triathlon = disciplines(:triathlon)
    get happenings_path(discipline_ids: [triathlon.id])

    assert_select 'td', {text: happenings(:kayak_regatta).name, count: 0}
  end

  test 'show' do
    happening = happenings(:kayak_regatta)
    get happening_path(happening)
    assert_select 'dd', happening.name
  end

  test 'show without discipline' do
    happening = happenings(:kayaking_no_discipline)
    get happening_path(happening)
    assert_select 'dd', happening.name
  end
end
