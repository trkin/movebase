require 'test_helper'

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  test 'redirect to root domain' do
    host! 'www.somedomain.com'
    get root_path
    assert_redirected_to root_url(host: 'somedomain.com')
  end
end
