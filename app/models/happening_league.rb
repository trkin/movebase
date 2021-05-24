class HappeningLeague < ApplicationRecord
  FIELDS = %i[happening league].freeze
  belongs_to :happening
  belongs_to :league
end
