class Venue < ApplicationRecord
  extend Mobility
  translates :name

  FIELDS = %i[name latitude longitude address city].freeze

  has_many :happenings, dependent: :destroy
  has_many :clubs, dependent: :destroy

  validates :name, presence: true
end
