require 'application_system_test_case'

class TranslationsTest < ApplicationSystemTestCase
  setup do
    @activity = activities(:walking)
    sign_in users(:support_staff)
  end

  test 'index and search' do
    visit translations_path
    assert_selector 'td', text: @activity.name

    fill_in 'Search', with: @activity.name
    assert_selector 'td', text: @activity.name

    fill_in 'Search', with: 'blabla'
    refute_selector 'td', text: @activity.name
  end

  test 'updating' do
    visit translations_path
    find("data-test=[#{@activity.id}]").click

    click_on I18n.t('Submit')
    assert_selector 'dd', text: 'blabla'
  end
end
