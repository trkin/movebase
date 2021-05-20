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

  def self.determine_kind_from_url(url)
    uri = URI url
    case uri.host
    when %w[f.me www.facebook.com]
      :facebook_page
    when %w[instagram.com]
      :instagram_page
    when %w[twitter.com]
      :twitter_page
    when %w[youtube.com]
      :youtube
    else
      :website
    end
  end
end
