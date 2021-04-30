require 'test_helper'

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  test 'redirect to root domain' do
    host! 'www.somedomain.com'
    get root_path
    assert_redirected_to root_url(host: 'somedomain.com')
  end

  test '#_set_locale_from_param' do
    user = users(:user)
    user.locale = 'sr-latin'
    user.save!
    sign_in user
    get root_path(locale: nil)
    assert_select "html[lang='sr-latin']"
  end
end
