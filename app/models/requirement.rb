class Requirement < ApplicationRecord
  extend Mobility
  translates :name, :description

  FIELDS = %i[name description].freeze

  enum kind: %i[equipment sped registration]

  # if there is no requirement, than discipline is allowed
  has_many :discipline_requirements, dependent: :destroy
end
