class ActivityAssociation < ApplicationRecord
  belongs_to :activity
  belongs_to :associated, class_name: 'Activity'

  # similar need to create in both directions
  enum kind: %i[consists_of similar]
end
