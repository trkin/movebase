class Activity < ApplicationRecord
  extend Mobility
  translates :name, :description

  FIELDS = %i[name description admin_notes].freeze

  has_and_belongs_to_many :disciplines
  has_many :activity_clubs, dependent: :destroy
  has_many :clubs, through: :activity_clubs
  has_many :links, as: :linkable

  validates :name, presence: true, uniqueness: true
end
