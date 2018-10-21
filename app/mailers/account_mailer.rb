class AccountMailer < ActionMailer::Base

  default :from => 'registrations@hpmelville.com'

  def registration(user_id)
    images_path = File.join(Rails.root, 'app/assets/images')
    attachments.inline['mail_top.jpg'] = File.read("#{images_path}/mail_top.jpg")
    @user = User.find(user_id)
    mail(:to => @user.email, :subject => '[hpmelville.com] Thank you for registering account')
  end

  def password_recovery(user_id)
    images_path = File.join(Rails.root, 'app/assets/images')
    attachments.inline['mail_top.jpg'] = File.read("#{images_path}/mail_top.jpg")
    @user = User.find(user_id)
    @link = password_reset_user_url(token: @user.password_token)
    mail(to: @user.email, subject: '[hpmelville.com] Password recovery instructions')
  end

  def user_locked(user_id)
    images_path = File.join(Rails.root, 'app/assets/images')
    attachments.inline['mail_top.jpg'] = File.read("#{images_path}/mail_top.jpg")
    @user = User.find(user_id)
    @link = password_reset_user_url(token: @user.password_token)
    mail(to: @user.email, subject: '[hpmelville.com] Account locked')
  end
end