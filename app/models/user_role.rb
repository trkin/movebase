class UserRole < ApplicationRecord
  FIELDS = %i[role].freeze

  belongs_to :user
  belongs_to :user_rolable, polymorphic: true, optional: true

  enum roles: %i[default support_staff club_admin].each_with_object({}) { |k, o| o[k] = k.to_s }
end
