module RequestHelper
  def android_app?
    request.env['HTTP_USER_AGENT'] == Const.common[:short_name]
  end

  def request_path_with_locale(path, locale)
    regexp = /#{I18n.available_locales.map { |l| "\/#{l}\\b" }.join('|')}/
    if path == '/' # rubocop:todo Style/CaseLikeIf
      "/#{locale}/"
    elsif path.match regexp
      path.sub regexp, "/#{locale}"
    else
      "/#{locale}#{path}"
    end
  end
end
