class Discipline < ApplicationRecord
  extend Mobility
  translates :name

  FIELDS = %i[name number_of_crew number_of_relays activity_id].freeze

  belongs_to :activity

  has_many :discipline_happenings, dependent: :destroy
  has_many :discipline_requirements, dependent: :destroy
  has_many :requirements, through: :discipline_requirements
  has_many :links, as: :linkable

  enum kind: %i[basic]

  validates :name, presence: true, uniqueness: true
end
