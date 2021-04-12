class DisciplineHappening < ApplicationRecord
  extend Mobility
  translates :name, :description

  acts_as_list

  FIELDS = %i[name description gender distance_m elevation_m max_time_s age_min
              age_max price_without_discount_cents start_time position].freeze

  attr_accessor :existing_or_new

  belongs_to :discipline
  accepts_nested_attributes_for :discipline
  belongs_to :happening

  has_many :discipline_happening_tags, dependent: :destroy

  enum gender: %i[any man women]

  def full_name # rubocop:todo Metrics/PerceivedComplexity, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/AbcSize
    gender_string = gender != 'any' ? I18n.t("#{gender}_short") : ''
    age_string = if age_min.present? && age_max.present?
                   "#{age_min} - #{age_max} #{I18n.t('years')}"
                 elsif age_min.present?
                   "#{age_min}+ #{I18n.t('years')}"
                 elsif age_max.present?
                   "- #{age_max} #{I18n.t('years')}"
                 else
                   ''
                 end
    distance_string = if distance_m.present?
                        if distance_m > 1000
                          "#{distance_m / 1000.0}km"
                        else
                          "#{distance_m}m"
                        end
                      else
                        ''
                      end
    "#{name} #{age_string} #{distance_string} #{gender_string}"
  end
end
