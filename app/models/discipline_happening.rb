class DisciplineHappening < ApplicationRecord
  extend Mobility
  translates :name

  belongs_to :discipline
  belongs_to :happening

  has_many :disciplines, dependent: :destroy

  enum gender: %i[any man women]

  def default_name
    return if discipline.blank?

    "#{discipline.name} #{age_min} #{age_max} #{distance_m} #{gender}"
  end
end
