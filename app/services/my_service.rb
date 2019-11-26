class MyService
  def initialize(url)
    @url = url
  end

  def perform
    uri = URI @url
    response_body = Net::HTTP.get uri
    Result.new response_body
  end
end
