class ParseUrl
  def initialize(url)
    @url = url
  end

  def perform
    uri = URI @url
    case uri.host
    when 'www.facebook.com'
      facebook uri
    else
      Notify.message 'ParseUrl_not_supported ' + @url
      Error.new 'Not supported'
    end
  rescue URI::InvalidURIError => e
    Error.new e.message
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
    Error.new e.message
  end
end
