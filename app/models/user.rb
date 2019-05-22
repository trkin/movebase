class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  FIELDS = %i[name email password password_confirmation].freeze

  has_many :club_users, dependent: :destroy

  validates :email, presence: true
end
