require 'test_helper'

class VenuesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:superadmin)
    @venue = venues(:novi_sad)
  end

  test 'should get index' do
    get venues_path
    assert_response :success
    assert_select 'div', @venue.name
  end

  test 'should get new' do
    get new_venue_path
    assert_response :success
  end

  test 'should create venue' do
    assert_difference('Venue.count') do
      post venues_path, params: { venue: { name: @venue.name } }
    end

    assert_js_redirected_to 'reload'
  end

  test 'should show venue' do
    get venue_url(@venue)
    assert_response :success
    assert_select 'dd', @venue.name
  end

  test 'should update venue' do
    patch venue_url(@venue), params: { venue: { name: @venue.name } }
    assert_js_redirected_to venue_path(@venue)
  end

  test 'should destroy venue' do
    assert_difference('Venue.count', -1) do
      delete venue_url(@venue)
    end

    assert_redirected_to venues_path
  end
end
