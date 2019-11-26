require 'test_helper'

class MyServiceTest < ActiveSupport::TestCase
  test 'success' do
    url = 'http://example.com'
    VCR.use_cassette :example_com do
      result = MyService.new(url).perform
      assert result.success?
    end
  end
end
