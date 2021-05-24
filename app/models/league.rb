class League < ApplicationRecord
  FIELDS = %i[name].freeze

  belongs_to :parent_league, class_name: 'League', optional: true
end
