require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  test 'should get contact' do
    get contact_path
    assert_response :success
  end

  test 'send message' do
    post contact_path, params: { contact: { email: 'my@email.com', text: 'hi' } }
    follow_redirect!
    assert_notice t('contact_thanks')
  end
end
