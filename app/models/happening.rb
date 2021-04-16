class Happening < ApplicationRecord
  extend Mobility
  translates :name, :description

  FIELDS = %i[venue_id club_id secondary_club_id name description recurrence start_date end_date].freeze

  serialize :recurrence
  attr_accessor :existing_or_new

  belongs_to :venue
  accepts_nested_attributes_for :venue
  belongs_to :club
  belongs_to :secondary_club, class_name: 'Club', optional: true

  has_many :discipline_happenings, -> { order position: :asc }, dependent: :destroy
  has_many :disciplines, through: :discipline_happenings
  has_many :links, as: :linkable

  validates :name, :start_date, :end_date, presence: true
  validate :_end_date_greater_or_equal_start_date

  before_validation :_default_values_on_create, on: :create

  def _end_date_greater_or_equal_start_date
    return if end_date.blank? || start_date.blank?
    return if end_date >= start_date

    errors.add :end_date, t('can_not_be_less_than_item_name', item_name: Happening.human_attribute_name(:start_date))
  end

  def multi_day?
    end_date != start_date
  end

  def _default_values_on_create
    self.end_date ||= start_date
  end

  def start_date_and_end_date_string
    if multi_day?
      "#{I18n.l start_date, format: :long} - #{I18n.l end_date, format: :long}"
    else
      I18n.l start_date, format: :long_with_week
    end
  end

  def multi_discipline?
    disciplines.uniq.size > 1
  end
end
