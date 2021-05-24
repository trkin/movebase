require 'test_helper'

class LinksControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:superadmin)
    @link = links(:link)
  end

  test 'should get index' do
    get links_path
    assert_response :success
    assert_select 'td', @link.linkable_id
  end

  test 'should search' do
    post search_links_path, params: { search: { value: @link.linkable_id } }
    assert_match @link.linkable_id, response_json[:data].join
    post search_links_path, params: { search: { value: 'blabla' } }
    refute_match @link.linkable_id, response_json[:data].join
  end

  test 'should create link' do
    assert_difference('Link.count') do
      post links_path, params: { link: { kind: @link.kind, linkable_id: @link.linkable_id, linkable_type: @link.linkable_type, url: @link.url } }
    end

    assert_js_redirected_to 'reload'
  end

  test 'should show link' do
    get link_url(@link)
    assert_response :success
    assert_select 'dd', @link.linkable_id
  end

  test 'should update link' do
    patch link_url(@link), params: { link: { kind: @link.kind, linkable_id: @link.linkable_id, linkable_type: @link.linkable_type, url: @link.url } }
    assert_js_redirected_to link_path(@link)
  end

  test 'should destroy link' do
    assert_difference('Link.count', -1) do
      delete link_url(@link)
    end

    assert_redirected_to club_path(@link.linkable)
  end
end
