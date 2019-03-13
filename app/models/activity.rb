class Activity < ApplicationRecord
  extend Mobility
  translates :name

  has_many :disciplines, dependent: :destroy
  has_many :activity_associations, dependent: :destroy
  has_many :consists_of_activities,
           -> { where(activity_associations: { kind: ActivityAssociation.kinds[:consists_of] }) },
           through: :activity_associations, source: :associated
  has_many :inversed_activity_associations,
           dependent: :destroy, class_name: 'ActivityAssociation',
           foreign_key: :associated, inverse_of: :associated
  has_many :used_in_activities,
           -> { where(activity_associations: { kind: ActivityAssociation.kinds[:consists_of] }) },
           through: :inversed_activity_associations, source: :activity

  def self_and_used_in_activities
    [self] + used_in_activities
  end
end
