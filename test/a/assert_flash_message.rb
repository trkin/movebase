class ActionDispatch::IntegrationTest
  # assert_flash_message with something like
  # assert_alert /You are already registered/
  def assert_alert(text)
    assert_select '[data-test=alert-holder]', text
  end

  def assert_notice(text)
    assert_select '[data-test=notice-holder]', text
  end

  def assert_alert_in_js(text)
    matches = response.body.match(/data-flash-message=\\'(.*?)\\'/)
    # text = "Name can't be blank"
    # escaped_text = "Name can\\\\&#39;t be blank"
    escaped_text = ActionController::Base.helpers.j ERB::Util.html_escape ActionController::Base.helpers.j text
    assert matches, "Can not find data-flash-message='' in response.body=#{response.body}"
    assert_equal matches[1], escaped_text
  end

  def assert_field_error(text)
    assert_select 'div.invalid-feedback', text
  end
end

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  def assert_alert(text)
    assert_selector '[data-test=alert-holder]', text: text, visible: false
  end

  def assert_notice(text)
    assert_selector '[data-test=notice-holder]', text: text, visible: false
  end

  def assert_field_error(text)
    assert_selector 'div.invalid-feedback', text: text
  end
end
