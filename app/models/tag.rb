class Tag < ApplicationRecord
  extend Mobility
  translates :name, :description

  enum kind: %i[terain]

  validates :name, presence: true, uniqueness: true
end
