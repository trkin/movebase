class DisciplineAssociation < ApplicationRecord
  belongs_to :discipline
  belongs_to :associated, class_name: 'Discipline'

  validates :associated, uniqueness: {scope: %i[discipline kind]}

  # When using 'similar' than create in both directions a->b b->a
  enum kind: %i[similar consists_of]
end
