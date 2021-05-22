require 'test_helper'

class HappeningsControllerTest < ActionDispatch::IntegrationTest
  #
  # Public pages
  #
  test 'index discipline_ids blank' do
    get happenings_path
    assert_response :success

    happening = happenings(:kayak_regatta)
    assert_select 'td', happening.name
  end

  test 'index triathlon' do
    triathlon = disciplines(:triathlon)
    get happenings_path(discipline_ids: [triathlon.id])

    assert_select 'td', { text: happenings(:kayak_regatta).name, count: 0 }
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

  #
  # Support staff pages
  #
  test 'unauthorized' do
    happening = happenings(:kayak_regatta)
    get edit_happening_path(happening)
    assert_redirected_to new_user_session_path

    sign_in users(:user)

    get new_happening_path
    follow_redirect!
    assert_alert 'Not Authorized HappeningPolicy update?'

    get new_from_link_happenings_path
    follow_redirect!
    assert_alert 'Not Authorized HappeningPolicy update?'

    get edit_happening_path(happening)
    follow_redirect!
    assert_alert 'Not Authorized HappeningPolicy update?'

    post edit_from_link_happenings_path(add_happening_from_link_form: { 'link': nil })
    follow_redirect!
    assert_alert 'Not Authorized HappeningPolicy update?'

    sign_in users(:support_staff)

    get new_happening_path
    assert_response :success

    get new_from_link_happenings_path
    assert_response :success

    get edit_happening_path(happening)
    assert_response :success

    post edit_from_link_happenings_path(add_happening_from_link_form: { 'link': nil })
    assert_response :success
  end

  test 'new_from_link #taken' do
    link = links(:link)
    sign_in users(:support_staff)

    post edit_from_link_happenings_path(add_happening_from_link_form: { 'url': link.url, discipline_id: disciplines(:discipline) })
    assert_response :success
    assert_alert_in_js 'Url has already been taken'
  end

  test 'create failed' do
    sign_in users(:support_staff)

    post happenings_path(happening: { name: 'a' })
    assert_alert_in_js 'Venue must exist, Organization must exist, Date can\'t be blank, and End date can\'t be blank'
  end

  test 'update failed' do
    happening = happenings(:happening)
    sign_in users(:support_staff)

    patch happening_path(happening), params: { happening: { name: '' } }
    assert_alert_in_js "Name can't be blank"
  end
end
