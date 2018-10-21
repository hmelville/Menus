class SessionsController < ApplicationController
  skip_authentication_check :only => :create

  def show
    redirect_to user_path
  end

  def create
    user = User.find_by_email(params[:email])
    if user
      if user.password_digest.present?
        authenticated = user.authenticate(params[:password])
      else
        authenticated = user.authenticate_with_md5(params[:password])
        user.migrate_password!(params[:password]) if authenticated
      end
    end

    if user && authenticated
      session[:user_id] = user.id
      redirect_to path_after_sign_in(user)
    else
      flash.now[:alert] = "Login details not recognised. Please try again."
      @hide_menu = true
      @body_class = 'home'
      render :template => "/pages/welcome"
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to path_after_sign_out
  end

  private

  def path_after_sign_in(user)
    return safe_back_to_uri || user
  end

  def path_after_sign_out
    root_path
  end
end