class Club < ApplicationRecord
  extend Mobility
  translates :name

  belongs_to :venue, optional: true

  has_many :happenings, dependent: :destroy
  has_many :club_users, dependent: :destroy
  # has_many :users, through: :club_users # do not use this since club
  # users can be disabled, so better is to use active_users
  has_many :active_users, -> { where club_users: { status: :active } }, through: :club_users, source: :user
end
