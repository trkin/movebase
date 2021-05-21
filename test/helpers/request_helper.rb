require 'test_helper'

class RequestHelperTest < ActionView::TestCase
  test '#request_path_with_locale existing locale in path' do
    actual = request_path_with_locale '/sr/123/english', 'en'
    expected = '/en/123/english'
    assert_dom_equal expected, actual
  end

  test '#request_path_with_locale root_path' do
    actual = request_path_with_locale '/', 'en'
    expected = '/en/'
    assert_dom_equal expected, actual
  end

  test '#request_path_with_locale existing locale on root path' do
    actual = request_path_with_locale '/sr', 'en'
    expected = '/en'
    assert_dom_equal expected, actual
  end

  test '#request_path_with_locale no locale in path' do
    actual = request_path_with_locale '/123/english', 'en'
    expected = '/en/123/english'
    assert_dom_equal expected, actual
  end
end
