class MyService
  def initialize(url = 'http://google.com')
    @url = url
  end

  def perform
    uri = URI @url
    response_body = Net::HTTP.get uri
    Result.new response_body
  end

  def perform_and_puts
    result = perform
    puts result.message
  end
end
