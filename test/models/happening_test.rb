require 'test_helper'

class HappeningTest < ActiveSupport::TestCase
  test 'valid fixture' do
    assert_valid_fixture happenings
  end

  test '_end_date_greater_or_equal_start_date' do
    happening = Happening.new start_date: Time.zone.today, end_date: Time.zone.today - 1.day
    happening.valid?
    assert_not_empty happening.errors[:end_date]
    happening.end_date = Time.zone.today
    happening.valid?
    assert_empty happening.errors[:end_date]
  end
end
