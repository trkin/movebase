VCR.configure do |config|
  config.cassette_library_dir = 'test/vcr_cassettes'
  config.hook_into :webmock
  config.ignore_localhost = true
  driver_hosts = Webdrivers::Common.subclasses.map { |driver| URI(driver.base_url).host }
  driver_hosts += ['googleapis.com']
  config.ignore_hosts driver_hosts
end
