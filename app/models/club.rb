class Club < ApplicationRecord
  extend Mobility
  translates :name, :long_name

  FIELDS = %i[kind name].freeze

  enum kind: %i[sport_organization personal]

  attr_accessor :existing_or_new

  belongs_to :venue
  accepts_nested_attributes_for :venue

  has_many :happenings, dependent: :destroy
  has_many :club_users, dependent: :destroy
  # has_many :users, through: :club_users # do not use this since club
  # users can be disabled, so better is to use active_users
  has_many :active_users, -> { where club_users: {position: ClubUser::ACTIVE_POSITIONS} }, through: :club_users, source: :user
  has_many :activity_clubs, dependent: :destroy
  has_many :activities, through: :activity_clubs
  has_many :links, as: :linkable

  validates :name, :venue, presence: true
end
