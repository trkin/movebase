class Const
  def self.common
    hash_or_error_if_key_does_not_exists(
      name: 'Move Base',
      # short_name is also use in config/sidekiq.yml and config/application.rb
      short_name: 'mb',
      show_ads: false,
      # default_url is required for links in email body or in links in controller
      # when url host is not available (for example rails console)
      # look below how default_url is used
      default_url: {
        host: (Rails.env.production? ? 'movebase.link' : 'localhost'),
        port: (Rails.env.development? ? Rack::Server.new.options[:Port] : nil),
        protocol: Rails.env.production? ? 'https' : 'http',
        locale: I18n.default_locale,
      },
    )
  end

  def self.collapse_keys
    hash_or_error_if_key_does_not_exists(
      new_message: 'new_message',
    )
  end

  def self.multiselect_size
    3
  end

  def self.hash_or_error_if_key_does_not_exists(hash)
    # https://stackoverflow.com/questions/30528699/why-isnt-an-exception-thrown-when-the-hash-value-doesnt-exist
    # raise if key does not exists hash[:non_exists] or hash.values_at[:non_exists]
    hash.default_proc = ->(_h, k) { raise KeyError, "#{k} not found!" }
    # raise when value not exists hash.key 'non_exists'
    def hash.key(value)
      k = super
      raise KeyError, "#{value} not found!" unless k

      k
    end
    hash
  end

  # https://stackoverflow.com/a/21249623/287166
  class ConstRailtie < Rails::Railtie
    link = Const.common[:default_url].symbolize_keys
    # for link urls in emails
    config.action_mailer.default_url_options = link
    # Set host for rails console:
    # Rails.application.routes.url_helpers.root_url
    # => "http://movebase.link/"
    # and also for tests, when you call `get root path` before actual request
    # for example: get clubs_path => /en/clubs
    # Note that locale parametar is set in ApplicationController#default_url_options
    # Remember that in system test when we use id we need to pass locale
    # visit club_path(club, locale: Rails.application.routes.default_url_options[:locale])
    # and to simulate non locale url use: clubs_path(locale: nil)
    config.after_initialize do
      Rails.application.routes.default_url_options = link
    end
    # for asset-url or img_tag in emails
    config.action_mailer.asset_host = "http://#{link[:host]}:#{link[:port]}"
    config.active_job.queue_name_prefix = Const.common[:short_name]
  end
end
