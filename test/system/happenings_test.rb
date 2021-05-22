require 'application_system_test_case'

class HappeningsTest < ApplicationSystemTestCase
  setup do
    @happening = happenings(:happening)
    sign_in users(:support_staff)
  end

  test 'edit discipline happening does not add time' do
    visit happening_path(@happening, locale: Rails.application.routes.default_url_options[:locale])

    discipline_happening = @happening.discipline_happenings.first
    find("[data-test='edit-discipline-happening-#{discipline_happening.id}']").click
    click_on "#{:update.to_s.humanize} #{Discipline.model_name.human}"
    assert_notice t_notice('successfully_updated', Discipline)

    discipline_happening.reload
    assert discipline_happening.start_time.nil?
  end
end
