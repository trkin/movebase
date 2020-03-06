require 'test_helper'

class RecurrenceFormTest < ActiveSupport::TestCase
  test 'weekly on wednesday' do
    happening = happenings(:kayak_regata)
    recurrence_form = RecurrenceForm.new(
      happening: happening,
      every: 'week',
      day: 3, # 'Wednesday',
      total: 2,
      custom_name: '{{ number }} Wednesday',
      start_number: 1,
    )

    assert_difference 'Happening.count', 2 do
      recurrence_form.save
      new1, new2 = happening.club.happenings.where(start_date: Date.current..).order(created_at: :asc).all
      assert_equal '1 Wednesday', new1.name
      assert_equal new1.start_date.strftime('%A'), 'Wednesday'
      assert_equal '2 Wednesday', new2.name
      assert_equal new2.start_date.strftime('%A'), 'Wednesday'
    end
  end

  test 'update existing in future' do
    happening = happenings(:kayak_regata)
    Timecop.freeze '2006-01-01' do
      recurrence_form = RecurrenceForm.new(
        happening: happening,
        every: 'week',
        day: 3, # 'Wednesday',
        total: 2,
        custom_name: '{{ number }} Wednesday',
        start_number: 1,
      )
      recurrence_form.save
    end

    Timecop.freeze '2006-01-08' do
      recurrence_form = RecurrenceForm.new(
        happening: happening,
        every: 'week',
        day: 4, # 'Thursday',
        total: 2,
        custom_name: '{{ number }} Thursday',
        start_number: 2,
        existing_update: 'future',
      )
      assert_difference 'Happening.count', 1 do
        recurrence_form.save
        new1, new2 = happening.club.happenings.where(start_date: Date.current..).order(start_date: :asc).all
        assert_equal '2 Thursday', new1.name
        assert_equal new1.start_date.strftime('%A'), 'Thursday'
        assert_equal '3 Thursday', new2.name
        assert_equal new2.start_date.strftime('%A'), 'Thursday'
      end
    end
  end
end
