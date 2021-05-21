class Discipline < ApplicationRecord
  extend Mobility
  translates :name

  FIELDS = %i[name number_of_crew number_of_relays admin_note].freeze +
           [
             {
               activity_ids: [],
             }
           ]

  has_and_belongs_to_many :activities

  has_many :discipline_happenings, dependent: :destroy
  has_many :happenings, through: :discipline_happenings
  has_many :discipline_requirements, dependent: :destroy
  has_many :requirements, through: :discipline_requirements
  has_many :links, as: :linkable

  # DisciplineAssociation
  has_many :discipline_associations, dependent: :destroy
  has_many :consists_of_disciplines,
           -> { where(discipline_associations: { kind: DisciplineAssociation.kinds[:consists_of] }) },
           through: :discipline_associations, source: :associated
  has_many :inversed_discipline_associations,
           dependent: :destroy, class_name: 'DisciplineAssociation',
           foreign_key: :associated, inverse_of: :associated
  has_many :used_in_disciplines,
           -> { where(discipline_associations: { kind: DisciplineAssociation.kinds[:consists_of] }) },
           through: :inversed_discipline_associations, source: :discipline
  has_many :similar_disciplines,
           -> { where(discipline_associations: { kind: DisciplineAssociation.kinds[:similar] }) },
           through: :discipline_associations, source: :associated

  enum kind: %i[basic]

  validates :name, presence: true, uniqueness: true
end
