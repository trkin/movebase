class Requirement < ApplicationRecord
  extend Mobility
  translates :name, :description

  enum kind: %i[equipment sped registration]

  # if there is no requirement, than discipline is allowed
  has_many :discipline_requirements, dependent: :destroy
end
