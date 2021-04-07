class DisciplineAssociation < ApplicationRecord
  belongs_to :discipline
  belongs_to :associated, class_name: 'Discipline'

  # When using 'similar' than create in both directions a->b b->a
  enum kind: %i[similar consists_of]
end
