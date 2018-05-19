class SettingsDecorator < ::BaseDecorator
  delegate_all

  def reminder_emails_send_time
    if model.reminder_emails?
      h.l(model.reminder_emails_send_time.strftime("%H:%M"))
    else
      nil
    end
  end

  def menu_rotation_start_date
    model.menu_rotation_start_date.strftime("%A %d/%m/%Y")
  end
end