class DisciplineHappening < ApplicationRecord
  extend Mobility
  translates :name, :description

  acts_as_list

  FIELDS = %i[
    discipline_id existing_or_new_discipline name description gender distance_m elevation_m max_time_s
    age_min age_max price_without_discount_cents start_time position
  ].freeze

  belongs_to :discipline
  accepts_nested_attributes_for :discipline
  attr_accessor :existing_or_new_discipline

  belongs_to :happening

  has_many :discipline_happening_tags, dependent: :destroy

  enum gender: %i[any man women]

  def full_name # rubocop:todo Metrics/PerceivedComplexity, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/AbcSize
    time_string = if start_time.present?
                    if !happening.multi_day? && start_time.to_date == happening.start_date
                      I18n.l start_time, format: :only_time
                    else
                      I18n.l start_time, format: :day_month_and_time
                    end
                  end
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
    elevation_string = I18n.t('elevation_m_name', m_name: "#{elevation_m}m") if elevation_m.present?
    limit_string = if max_time_s.present?
                     I18n.t('limit_time_name',
                            time_name: ActionController::Base.helpers.distance_of_time_in_words(max_time_s))
                   end
    "#{time_string} #{name} #{age_string} #{distance_string} #{elevation_string} #{gender_string} #{limit_string}"
  end
end
