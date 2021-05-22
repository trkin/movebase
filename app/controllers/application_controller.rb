class ApplicationController < ActionController::Base
  around_action :_set_locale_from_param
  before_action :_redirect_to_root_domain
  # before_action :_sleep_some_time

  def _sleep_some_time
    sleep 2
  end

  def _set_locale_from_param
    locale = params[:locale] if params[:locale].present? && I18n.available_locales.include?(params[:locale].to_s.to_sym)
    locale ||= current_user&.locale ||
               _get_locale_from_http_accept_language ||
               I18n.default_locale
    I18n.with_locale locale.to_sym do # rubocop:todo Style/ExplicitBlockArgument
      yield
    end
  end

  def _get_locale_from_http_accept_language
    request.env['HTTP_ACCEPT_LANGUAGE'].to_s.scan(/^[a-z]{2}/).first
  end

  def _redirect_to_root_domain
    # request.host is www.movebase.link, request.domain is movebase.link
    return if request.host == request.domain
    return if request.host == '127.0.0.1' # return for system test

    redirect_to root_url(host: request.domain)
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/PerceivedComplexity
  # To use, you need to initialize object and call with params and redirect path
  # redirect_path can be proc so it redirects to show page after create
  # Look for example admin/users_controller.rb
  #
  #  def new
  #    @subscriber = current_user.company.subscribers.new country: current_user.company.country
  #    render partial: 'form', layout: false
  #  end
  #  def create
  #    @subscriber = current_user.company.subscribers.new
  #    update_and_render_or_redirect_in_js @subscriber, _subscriber_params, ->(subscriber) { subscriber_path(subscriber) }
  #  end
  def update_and_render_or_redirect_in_js(item, item_params, redirect_path_or_proc = nil, partial = 'form', notice = nil)
    notice ||= if item.new_record?
                 helpers.t_notice('successfully_created', item.class)
               else
                 helpers.t_notice('successfully_updated', item.class)
               end
    item.assign_attributes item_params
    # if you need some custom checks you can add errors before calling this proc
    if item.errors.blank? && item.save
      flash[:notice] = flash.now[:notice] = notice
      redirect_path = if redirect_path_or_proc.instance_of? Proc
                        redirect_path_or_proc.call item
                      else
                        redirect_path_or_proc
                      end
      if redirect_path.present?
        render js: %(
          window.location.assign('#{redirect_path}');
        )
      else
        render js: %(
          window.location.reload();
        )
      end
    else
      flash.now[:alert] = item.errors.full_messages.to_sentence
      render js: _replace_remote_form_with_partial(partial)
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/PerceivedComplexity

  def _replace_remote_form_with_partial(partial)
    %(
        var form = document.getElementById('remote-form');
        var parent = form.parentNode;
        var new_form = document.createElement('div');
        new_form.innerHTML = '#{helpers.j helpers.render(partial) + helpers.render('layouts/flash_notice_alert_jbox')}';
        parent.replaceChild(new_form, form);
    )
  end

  rescue_from ActionPolicy::Unauthorized do |exception|
    raise exception if Rails.env.development?

    message = "#{exception.message} #{exception.policy} #{exception.rule}"
    respond_to do |format|
      format.html { redirect_to root_path, alert: message }
      format.json { render json: { error_message: message, error_status: :bad_request }, status: :bad_request }
    end
  end

  # https://stackoverflow.com/questions/8224245/rails-routes-with-optional-scope-locale/8237800#8237800
  def default_url_options(_options = {})
    { locale: I18n.locale }
  end

  def after_sign_in_path_for(resource)
    helpers.request_path_with_locale stored_location_for(resource), resource.locale
  end
end
