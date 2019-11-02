class ClubUser < ApplicationRecord
  FIELDS = %i[position].freeze
  ACTIVE_POSITIONS = %i[admin operator].freeze
  belongs_to :club
  belongs_to :user

  enum position: %i[admin operator invited disabled].each_with_object({}) { |k, o| o[k] = k.to_s }
end
