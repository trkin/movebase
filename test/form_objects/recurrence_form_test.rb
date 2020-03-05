require 'test_helper'

class RecurrenceFormTest < ActiveSupport::TestCase
  test 'weekly on wednesday' do
    happening = happenings(:kayak_regata)
    recurrence_form = RecurrenceForm.new(
      happening: happening,
      every: 'week',
      day: 'Wednesday',
      total: 2,
      custom_name: '{{ number }} some_name',
      start_number: 1,
    )

    assert_difference 'Happening.count', 2 do
      recurrence_form.save
      new1, new2 = happening.club.happenings.where(start_date: Date.current..).order(created_at: :asc).all
      assert_equal '1 some_name', new1.name
      assert_equal new1.start_date.strftime('%A'), 'Wednesday'
      assert_equal '2 some_name', new2.name
      assert_equal new2.start_date.strftime('%A'), 'Wednesday'
    end
  end
end
