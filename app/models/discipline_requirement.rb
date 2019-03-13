class DisciplineRequirement < ApplicationRecord
  belongs_to :discipline
  belongs_to :requirement
end
