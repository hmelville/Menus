class PagesController < ApplicationController
  skip_authentication_check
  allow_browser_to_cache

  def show
      render :template => current_page
  end

  def browser_aware
    session[:old_browser_aware] = true
  end

  def device_aware
    session[:unsupported_device_aware] = true
  end

  def welcome
    @body_class = "home"
    welcome_all('welcome')
  end

  protected

  def welcome_all(target)
    if current_user
      redirect_to user_path
    else
      @hide_menu = true
      render target
    end
  end

  def page_id
    params[:id].to_s.downcase.strip
  end

  def current_page
    "pages/#{page_id}"
  end
end
