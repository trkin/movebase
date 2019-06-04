class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable

  FIELDS = %i[name email password password_confirmation].freeze

  has_many :club_users, dependent: :destroy

  validates :email, presence: true

  # rubocop:disable Metrics/MethodLength
  def self.from_omniauth(auth, params)
    user = find_by(uid: auth.uid)
    return user if user

    user = find_by(email: auth.info.email)
    if user
      user.uid = auth.uid
      user.skip_confirmation! # this will just add confirmed_at = Time.now
      user.save!
      return user
    end

    # create new user with some password
    user = User.new(
      email: auth.info.email,
      uid: auth.uid,
      password: Devise.friendly_token[0, 20],
      picture_url: auth.info.image,
      confirmed_at: Time.zone.now,
    )
    user.save!
    user
  end
  # rubocop:enable Metrics/MethodLength

  def destroy_my_data!
    # TODO: remove all dependencies
  end
end
