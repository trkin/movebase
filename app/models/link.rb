class Link < ApplicationRecord
  FIELDS = %i[linkable_id linkable_type kind url visible].freeze
  KINDS = %i[
    website
    email
    phone
    long_name
    results
    photos
    facebook_page
    facebook_event
    facebook_group
    instagram_page
    twitter_page
    viber_group
    wikipedia
    youtube
    registration
    route_track
    facebook_video
  ].each_with_object({}) { |k, o| o[k] = k.to_s }
  enum kind: KINDS

  belongs_to :linkable, polymorphic: true
  validates :url, :kind, presence: true
end
