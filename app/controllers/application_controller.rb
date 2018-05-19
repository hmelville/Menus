class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action :set_request_uuid
  before_action :create_settings
  before_filter :prevent_browser_caching

  helper_method :safe_back_to_uri

  def create_settings
    unless Setting.all.present?
      setting = Setting.new(menu_rotation_weeks: 4, menu_rotation_start_date: Date.today, reminder_emails: false, default_shopping_days: 7).save
      redirect_to edit_setting_path(setting)
    end
  end

  # Redirects to the URI given by {#safe_back_to_uri} or if that is not present
  # then to the supplied default
  def redirect_to_back(default_path)
    redirect_to safe_back_to_uri || default_path
  end

  # Redirects to the URI given by {#safe_back_to_uri} or if that is not present
  # then to the referer or if that is not present to the supplied default
  def redirect_to_back_or_referer(default_path)
    if request.referer
      redirect_to safe_back_to_uri || sanitise_uri(request.referer) || default_path
    else
      redirect_to_back(default_path)
    end
  end

  # Sanitises (to prevent CSS) and returns the content of params[:back_to], or nil
  # if there is no such parameter.
  def safe_back_to_uri
    sanitise_uri(params[:back_to])
  end

  # Sanitises the supplied uri to prevent CSS. Returns nil if the supplied uri is
  # not a valid URI.
  def sanitise_uri(unsafe_uri)
    u = URI.parse(unsafe_uri)
    if u.query.present?
      u.path + "?" + u.query
    else
      u.path
    end
  rescue URI::InvalidURIError
    nil
  end

  private

    # sets the http headers to prevent the browser caching the response
    # used to prevent the browser back-button from showing pages with personal data
    def prevent_browser_caching
      response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
      response.headers["Pragma"] = "no-cache"
      response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
    end

    def set_request_uuid
      Thread.current[:request_uuid] = request.uuid
    end
end