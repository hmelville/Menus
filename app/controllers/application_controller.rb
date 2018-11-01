class ApplicationController < ActionController::Base
  protect_from_forgery

  skip_before_filter :verify_authenticity_token
  before_filter :secure_headers
  before_filter :prevent_browser_caching
  before_filter :get_platform

  before_action :set_back, only: [:new, :edit]
  before_action :set_request_uuid
  before_filter :prevent_browser_caching

  helper_method :safe_back_to_uri

  def self.skip_authentication_check(*arguments)
    skip_before_filter :require_user, *arguments
  end

  def self.check_authentication(*arguments)
    before_filter :require_user, *arguments
  end

  def self.allow_browser_to_cache(*arguments)
    skip_before_filter :prevent_browser_caching
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by_id(session[:user_id])
      session.delete(:user_id) unless @current_user
    end
    @current_user
  end

  def sign_in_user(user)
    session[:user_id] = user.id
  end

  def user_signed_in?
    !!current_user
  end

  def user_signed_out?
    !user_signed_in?
  end

  def require_user
    if user_signed_in?
      current_user.update_columns(last_login_ip_address: request.remote_ip, last_login_datetime: DateTime.now)
    else
      redirect_to root_path(:back_to => sanitise_uri(request.fullpath), :unauthenticated => true)
    end
  end

  def back_to_key
  end

  def set_back
    session[back_to_key] = request.referer.gsub('&reset_back=true', '') if request.referer && params[:reset_back].present?
  end

  def go_back(default_path = nil)
    back_to = session[back_to_key]
    session.delete(back_to_key)
    redirect_to back_to || default_path || root_path
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


  def secure_headers
    response.headers['X-Frame-Options'] = "DENY"
  end


  rescue_from CanCan::AccessDenied do |exception|
    logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
    render "/pages/not_authorised", locals: {exception: exception}
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    logger.debug "Record Not Found error #{exception}"
    render "/pages/not_found", locals: {exception: "Oops we couldn't find what you were looking for!"}
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

    def get_platform
      ua = UserAgent.parse(request.user_agent)
      @platform = ua.platform
    end

    helper_method :current_user, :user_signed_in?, :user_signed_out?
    check_authentication
end