class Tag < ApplicationRecord
  enum kind: %i[terain]

  validates :name, presence: true, uniqueness: true
end
