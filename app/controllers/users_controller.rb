class UsersController < ApplicationController
  skip_authentication_check only: [:new, :create, :password, :password_sent, :password_reset, :update_password]
  before_action :require_no_user, only: [:new, :create, :password, :password_sent, :password_reset, :update_password]

  before_action :setup

  BACK_TO_KEY = :user_return_to

  def back_to_key
    BACK_TO_KEY
  end

  # Registration process
  def new
    @user = User.new
    @user.use_budgets = true
    @user.use_menus = true
    @user.menu_rotation_weeks = 4
    @user.menu_rotation_start_date = Date.today
    @user.reminder_emails = false
    @user.default_shopping_days = 7

    @user_d = UserDecorator.decorate(@user).decorate
    @hide_menu = true
  end

  def create
    @user = User.new(user_params)
    @user.created_by_ip = request.remote_ip

    # Check the honey-trap. If this param has content then the form was submitted by a Bot.
    if params[:name].present?
      @user.errors[:base] = "An error occurred."
      ExceptionNotifier.notify_exception(User::RegistrationDenied.new("Fell into Honey Trap"), data: {honeytrap: params[:name]}.merge(@user.attributes))
      render action: :new
    else
      if @user.save
        sign_in_user(@user)
        current_user.process_menu_rotations
        redirect_to user_path, notice: "Account created."
      else
        # reset the email validation flag
        @user.email_is_valid = "retry"
        render action: :new
      end
    end
  end
  #/ Registration process

  # Password recovery
  def password
    @hide_menu = true
  end

  def password_sent
    @hide_menu = true
    @user = User.find_by_email(params[:email])
    if @user
      @user.set_password_token!
      AccountMailer.delay(queue: "Email").password_recovery(@user.id)
    elsif params[:email].blank? || !(params[:email] =~ /@/)
      flash[:alert] = I18n.t :blank, scope: :request_password_reset
      return redirect_to password_user_path
    end
  end

  def password_reset
    @hide_menu = true
    @user = User.find_by_password_token(params[:token])
    @purpose = params[:purpose]
    if @user.nil?
      flash[:alert] = I18n.t :invalid, scope: @purpose
      if @purpose == "user_activation"
        return redirect_to new_user_path
      else
        return redirect_to password_recovery_user_path
      end
    elsif @user.password_token_expires < DateTime.now
      flash[:alert] = I18n.t :expired, scope: @purpose
      return redirect_to password_recovery_user_path
    end
  end

  def update_password
    @purpose = params[:purpose]
    if @user = User.find_by_password_token(params[:token])
      if params[:user][:password].blank?
        flash[:alert] = I18n.t :blank, scope: :password_reset
        redirect_to password_reset_user_path(token: params[:token])
      else
        @user.attributes = {
          password: params[:user][:password],
          password_confirmation: params[:user][:password_confirmation]
        }
        @user.valid?
        if @user.errors.empty? || [:password, :password_digest, :password_confirmation].all? {|v| @user.errors[v].empty? }
          # reset the password token to one that has already expired (this also saves user)
          @user.set_password_token!(-1)
          # Set the failed login counter back to zero and clear the lockout timer
          @user.reset_login_counter!
          sign_in_user(@user)
          flash[:notice] = I18n.t :success, scope: @purpose
          return redirect_to user_path
        else
          render 'password_reset'
        end
      end
    else
      flash[:alert] = I18n.t :invalid, scope: @purpose
      if @purpose == "user_activation"
        return redirect_to new_user_path
      else
        return redirect_to password_recovery_path_path
      end
    end
  end

  def show
    @user = current_user
    @user_d = UserDecorator.decorate(@user).decorate
  end

  def edit
    @user = current_user
    @user_d = UserDecorator.decorate(@user).decorate
  end

  def close
    @user = current_user
  end

  def update
    @user = current_user
    if authorized_for_update?
      if @user.update_attributes(user_params)
        if @user.account_closed?
          reset_session
          flash[:alert] = "Your user account has been closed successfully"
          return redirect_to root_path
        else
          return redirect_to user_path, notice: "Successfully updated user details."
        end
      end
    else
      @user.attributes = user_params
      # validate model to show all errors
      @user.valid?
      # TODO change it, move to model
      @user.errors[:old_password] << "is invalid"
    end

    # reset the email validation flag
    @user.email_is_valid = "retry"
    render action: "edit"
  end

  private

    def setup
      case action_name
      when 'new','create'
        @page_heading = "New User"
        @buttons = %i(save cancel)
      when 'edit','update'
        @page_heading = "Edit My Details"
        @buttons = %i(save cancel close)
      when 'show'
        @page_heading = "My Details"
        @buttons = %i(edit delete index)
      end
    end

    def require_no_user
      if user_signed_in?
        redirect_to root_path
      end
    end

    def log_user_out
      if user_signed_in?
        reset_session
        redirect_to request.path
      end
    end

    def authorized_for_update?
      params[:user][:password].present? && current_user.authenticate(params[:user][:old_password]) ||
        params[:user][:password].blank?
    end

    def user_params
      params.require(:user).permit(User.permitted_attributes)
    end
end