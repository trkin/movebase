require 'test_helper'

class Devise::MyRegistrationsControllerTest < ActionDispatch::IntegrationTest
  test 'sign up' do
    assert_difference 'User.count', 1 do
      post user_registration_path, params: { user: { email: 'my@email.com', password: 'my_password', password_confirmation: 'my_password' } }
      assert_redirected_to root_path
    end
  end
end
