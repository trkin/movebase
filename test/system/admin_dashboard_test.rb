require 'application_system_test_case'

class AdminDashboardTest < ApplicationSystemTestCase
  test 'TaskWithErrorJob' do
    sign_in users(:superadmin)
    visit admin_dashboard_path
    click_on 'sample-error-in-sidekiq'
  end
end
