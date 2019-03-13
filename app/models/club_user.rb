class ClubUser < ApplicationRecord
  belongs_to :club
  belongs_to :user

  enum status: %i[unconfirmed active disabled]
end
