require 'test_helper'

class TranslateFormTest < ActiveSupport::TestCase
  test '#initialize' do
    activity = activities(:running)
    translate_form = TranslateForm.new(record: activity, column_name: :name)
    assert_equal translate_form.column_value, activity.name
  end

  test '#save' do
    activity = activities(:running)
    translate_form = TranslateForm.new(record: activity, column_name: :name, column_value: 'new_name')
    assert translate_form.save
    activity.reload
    assert_equal 'new_name', activity.name
  end
end
