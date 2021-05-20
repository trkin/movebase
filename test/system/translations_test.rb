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
    find("[data-test='#{@activity.id}']").click

    find('[data-test=translate-form-column-value]').set('blabla')
    click_on I18n.t('update')
    assert_notice t_notice('successfully_updated', TranslateForm)
    assert_selector 'td', text: 'blabla'
  end
end
