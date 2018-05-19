class BaseDecorator < Draper::Decorator

  def to_yesno(val)
    if (ActiveRecord::ConnectionAdapters::Column::TRUE_VALUES + %w(y Y Yes yes YES)).include?(val)
      'Yes'
    elsif (ActiveRecord::ConnectionAdapters::Column::FALSE_VALUES + %w(n N No no NO)).include?(val)
      'No'
    else
      ''
    end
  end
end
