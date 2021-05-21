class BuildHappeningFromLink
  def initialize(link, discipline_id)
    @link = link
    @discipline_id = discipline_id
  end

  def perform
    return Error.new(I18n.t('errors.messages.blank')) if @link.blank?

    uri = URI @link
    case uri.host
    when 'www.facebook.com', 'web.facebook.com'
      facebook uri
    when 'trka.rs'
      trkars uri
    else
      msg = I18n.t('not_implemented_for_item_name', item_name: uri.host || @link)
      Error.new msg
    end
  rescue URI::InvalidURIError => e
    Error.new "BuildHappeningFromLink #{e.message}"
  end

  def facebook(uri)
    response_body = Net::HTTP.get uri
    page = Nokogiri::HTML response_body
    element = page.css('script[type="application/ld+json"]').first
    raise ArgumentError, 'no json element' if element.blank?

    json = JSON[element.text]
    result = {
      happening_name: json['name'],
      happening_description: json['description'],
      happening_start_date: Date.parse(json['startDate']),
      happening_end_date: Date.parse(json['endDate']),
    }
    if json['location']['@type'] == 'Place'
      lat, _, long, = json['location']['name'].split(' ')
      result[:happening_venue_attributes_latitude] = lat
      result[:happening_venue_attributes_longitude] = long
    end

    Result.new 'OK', json: result
  rescue ArgumentError => e
    Error.new "BuildHappeningFromLink#facebook #{e.message}"
  end

  def trkars(uri)
    response_body = Net::HTTP.get uri
    page = Nokogiri::HTML response_body
    happening_name = page.css('.event-title').text.strip
    _, start_date, _, _, club_name, email, website = page.css('.col-sm-10').map(&:text).map(&:strip)
    array_of_discipline_happening_distance_and_name = page.css('.list-group-item a').map(&:text).map(&:strip)
    raise 'trkars should have 7 col-sm-10' unless page.css('.col-sm-10')
    raise 'trkars undefined columns' unless [happening_name, start_date, club_name, email, website].all?

    # trka.rs is using cyrilic, but clubs could use latin for their club name
    # so we will stick with latin
    latin_club_name = club_name.to_lat
    latin_happening_name = happening_name.to_lat

    happening = nil
    Mobility.with_locale 'sr-latin' do
      happening = Happening.new name: latin_happening_name, start_date: start_date
      club = Club.i18n.find_by(name: latin_club_name) || Mobility.with_locale('en') { Club.i18n.find_by(name: latin_club_name) }
      if club.present?
        happening.club = club
      else
        happening.club_attributes = { name: latin_club_name }
      end
      array_of_discipline_happening_distance_and_name.each do |distance_and_name|
        reg_result = distance_and_name.match(/\[(\d*.\d*) km\] (.*)/)
        raise "trkars distance_and_name format = #{distance_and_name}" unless reg_result.size == 3

        distance = reg_result[1].to_d
        name = reg_result[2]
        happening.discipline_happenings.new discipline_id: @discipline_id, name: name, distance_m: distance * 1000
      end

      website_link = page.css('.col-sm-10').last.css('a').last['href']
      happening.links.build url: website_link, kind: Link.determine_kind_from_url(website_link)
      happening.links.build url: uri, kind: Link.kinds[:registration]
    end
    Result.new 'OK', happening: happening
  end
end
