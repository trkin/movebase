class ApplicationController < ActionController::Base
  around_action :_set_locale_from_session
  before_action :_redirect_to_root_domain
  # before_action :_sleep_some_time

  def _sleep_some_time
    sleep 2
  end

  def _set_locale_from_session
    locale = current_user&.locale ||
             _get_locale_from_session ||
             _get_locale_from_http_accept_language_and_set_to_session
    if locale.present?
      I18n.with_locale locale.to_sym do # rubocop:todo Style/ExplicitBlockArgument
        yield
      end
    else
      yield
    end
  end

  def _get_locale_from_session
    return session[:locale] if session[:locale].present?
  end

  def _get_locale_from_http_accept_language_and_set_to_session
    locale = request.env['HTTP_ACCEPT_LANGUAGE'].to_s.scan(/^[a-z]{2}/).first
    session[:locale] = locale if locale.present? && I18n.available_locales.include?(locale.to_sym)
  end

  def _redirect_to_root_domain
    # request.host is www.movebase.link, request.domain is movebase.link
    return if request.host == request.domain

    redirect_to root_url(host: request.domain)
  end

  # rubocop:disable Metrics/AbcSize
  def set_locale
    if params[:locale].present? && I18n.available_locales.include?(params[:locale].to_s.to_sym)
      session[:locale] = params[:locale]
      if current_user.present? && current_user.locale != params[:locale]
        current_user.locale = params[:locale]
        current_user.save!
        flash[:notice] = t('data_item_name_successfully_updated', item_name: User.human_attribute_name(:locale))
      end
    end
    redirect_to root_path
  end
  # rubocop:enable Metrics/AbcSize

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
  def update_and_render_or_redirect_in_js(item, item_params, redirect_path_or_proc, partial = 'form', notice = nil)
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
      render js: %(
        var form = document.getElementById('remote-form');
        var parent = form.parentNode;
        var new_form = document.createElement('div');
        new_form.innerHTML = '#{helpers.j helpers.render(partial) + helpers.render('layouts/flash_notice_alert_jbox')}';
        parent.replaceChild(new_form, form);
      )
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/PerceivedComplexity
end
