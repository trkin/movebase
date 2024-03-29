require 'test_helper'

class BuildHappeningFromLinkTest < ActiveSupport::TestCase
  #
  #  trka.rs
  #

  test 'trkars existing discipline new club' do
    link = 'https://trka.rs/event/210/'
    VCR.use_cassette :trkars_event do
      discipline = disciplines(:running)
      result = BuildHappeningFromLink.new(link, discipline.id).perform
      assert result.success?
      happening = result.data.happening
      assert_equal '12. Trka prijateljstva Kula', happening.name
      assert_equal Date.parse('2021-06-19'), happening.start_date
      assert_equal 'AK Hajduk maraton tim Kula', happening.club.name

      discipline_happening10, discipline_happening5 = happening.discipline_happenings.to_a
      assert_equal '10 km', discipline_happening10.name
      assert_equal 10_000, discipline_happening10.distance_m
      assert_equal '5 km', discipline_happening5.name
      assert_equal 5_000, discipline_happening5.distance_m

      website_link, registration_link = happening.links.to_a
      assert_equal link, registration_link.url
      assert_equal 'https://trkaprijateljstva.rs/', website_link.url
      assert_difference 'Club.count', 1 do
        happening.venue_attributes = { name: 'some place' }
        happening.save!
      end
    end
  end

  test 'trkars existing discipline existing club' do
    link = 'https://trka.rs/event/210/'
    club = clubs(:club)
    club.name = 'AK Hajduk maraton tim Kula'
    club.save!
    VCR.use_cassette :trkars_event do
      discipline = disciplines(:running)
      result = BuildHappeningFromLink.new(link, discipline.id).perform
      assert result.success?
      happening = result.data.happening
      assert_equal club, happening.club
      assert_equal '12. Trka prijateljstva Kula', happening.name
      assert_equal Date.parse('2021-06-19'), happening.start_date
      assert_equal 'AK Hajduk maraton tim Kula', happening.club.name

      discipline_happening10, discipline_happening5 = happening.discipline_happenings.to_a
      assert_equal '10 km', discipline_happening10.name
      assert_equal 10_000, discipline_happening10.distance_m
      assert_equal '5 km', discipline_happening5.name
      assert_equal 5_000, discipline_happening5.distance_m

      website_link, registration_link = happening.links.to_a
      assert_equal link, registration_link.url
      assert_equal 'https://trkaprijateljstva.rs/', website_link.url

      assert_difference 'Club.count', 0 do
        happening.venue_attributes = { name: 'some place' }
        happening.save!
      end
    end
  end

  #
  # facebook.com/events
  #

  test 'facebook existing discipline new club' do
  end
end
