require 'application_system_test_case'

class LinksTest < ApplicationSystemTestCase
  setup do
    @link = links(:link)
    sign_in users(:superadmin)
  end

  test 'index and search' do
    visit links_url
    assert_selector 'td', text: @link.linkable_id
    fill_in 'Search', with: @link.linkable_id
    assert_selector 'td', text: @link.linkable_id
    fill_in 'Search', with: 'blabla'
    refute_selector 'td', text: @link.linkable_id
  end

  test 'creating a Link' do
    visit club_path(@link.linkable, locale: Rails.application.routes.default_url_options[:locale])
    click_on t_crud('add_new', Link)

    fill_in 'Url', with: @link.url
    click_on 'Create Link'

    assert_notice 'Link successfully created'
  end

  test 'updating a Link' do
    visit links_url
    click_on @link.id
    click_on 'Edit'

    fill_in 'Url', with: 'blabla'
    click_on 'Update Link'

    assert_notice 'Link successfully updated'
    assert_selector 'dd', text: 'blabla'
  end

  test 'destroying a Link' do
    visit links_url
    click_on @link.id
    click_on 'Edit'
    page.accept_confirm do
      click_on 'Delete'
    end

    assert_notice 'Link successfully deleted'
  end
end
