class Link < ApplicationRecord
  FIELDS = %i[linkable_id linkable_type kind url].freeze
  KINDS = %i[
    club_website
    club_facebook_page
    happening_website
    happening_results
    happening_photos
  ].each_with_object({}) { |k, o| o[k] = k.to_s }
  enum kind: KINDS

  belongs_to :linkable, polymorphic: true
  validates :url, presence: true
end
