require 'test_helper'

class TranslationsControllerTest < ActionDispatch::IntegrationTest
  test 'unauthorized' do
    sign_in users(:kayak_admin)
    get translations_path
    follow_redirect!
    assert_alert 'Not Authorized AdminPolicy translations?'
  end

  test 'see disciplines' do
    sign_in users(:support_staff)
    get translations_path(model: 'Activity', column_name: 'name')
    assert_response :success
  end
end
