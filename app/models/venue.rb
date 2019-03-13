class Venue < ApplicationRecord
  has_many :happenings, dependent: :destroy
  has_many :clubs, dependent: :destroy
end
