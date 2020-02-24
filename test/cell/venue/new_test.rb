require 'test_helper'
class VenueCellNewTest < Cell::TestCase
  test 'renders' do
    venue = venues(:novi_sad)
    html = cell(Venue::Cell::New, venue, context: { controller: OpenStruct.new(url_options: {}) }).()
    assert_match /#{venue.name}/, html.to_s
  end

  def self.controller_class
    VenuesController
  end
end
