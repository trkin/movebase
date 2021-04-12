class Venue < ApplicationRecord
  extend Mobility
  translates :name

  geocoded_by :address
  reverse_geocoded_by :latitude, :longitude

  FIELDS = %i[name latitude longitude address city google_map_link].freeze

  has_many :happenings, dependent: :destroy
  has_many :clubs, dependent: :destroy

  validates :name, presence: true

  scope :cities, -> { where(is_a_city: true) }
end
