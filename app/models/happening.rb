class Happening < ApplicationRecord
  belongs_to :venue
  belongs_to :club, optional: true

  has_many :discipline_happenings, dependent: :destroy

  enum repeating: %i[no_repeating daily_repeating weekly_repeating yearly_repeating]

  validate :_end_date_greater_or_equal_start_date

  def _end_date_greater_or_equal_start_date
    return if end_date.blank? || start_date.blank?
    return if end_date >= start_date

    errors.add :end_date, t('can_not_be_greater_than_item_name', item_name: Happening.human_attribute_name(:start_date))
  end
end
