require 'test_helper'

class TranslateMultipleFormTest < ActiveSupport::TestCase
  test 'to_cyr' do
    activity = activities(:running)
    activity_no_sr = activities(:walking)
    activity_no_sr.name_backend.write(:sr, '')
    activity_no_sr_and_sr_latin = activities(:swimming)
    activity_no_sr_and_sr_latin.name_backend.write('sr-latin', '')
    activity_no_sr_and_sr_latin.name_backend.write('sr', '')
    translate_multiple_form = TranslateMultipleForm.new(column_name: :name, from_locale: 'sr-latin', to_locale: 'sr', records: [activity, activity_no_sr, activity_no_sr_and_sr_latin])
    assert translate_multiple_form.save
    assert_equal I18n.t('already_exists_count_blank_source_count_successfully_translated_count', already_exists_count: 1, blank_source_count: 1, successfully_translated_count: 1), translate_multiple_form.message
    assert_equal activity_no_sr.name_backend.read('sr-latin').to_cyr, activity_no_sr.name_backend.read(:sr)
  end
end
