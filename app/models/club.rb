class Club < ApplicationRecord
  extend Mobility
  translates :name, :long_name

  FIELDS = %i[name long_name website email phone national_id].freeze

  enum kind: %i[sport_organization personal]

  attr_accessor :existing_or_new

  belongs_to :venue
  accepts_nested_attributes_for :venue

  has_many :happenings, dependent: :destroy
  has_many :club_users, dependent: :destroy
  # has_many :users, through: :club_users # do not use this since club
  # users can be disabled, so better is to use active_users
  has_many :active_users, -> { where club_users: { status: :active } }, through: :club_users, source: :user
  has_many :activity_clubs, dependent: :destroy
  has_many :activities, through: :activity_clubs

  validates :name, :venue, presence: true
end
