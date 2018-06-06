class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if record.respond_to?(:email_is_valid) && ["valid_email", "invalid_email"].include?(record.try(:email_is_valid))
      if record.email_is_valid == "invalid_email"
        record.errors[attribute] << "address not valid"
      end
    end
  end
end
