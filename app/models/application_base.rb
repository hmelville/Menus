class ApplicationBase < ActiveRecord::Base
  self.abstract_class = true

  # Writes the supplied message into the log and emails it in a notification. If msg is an Exception it writes
  # msg.message and msg.backtrace into the log
  def self.log_and_notify(msg)
    if msg.kind_of?(Exception)
      Rails.logger.warn(msg.message+"\n"+Rails.backtrace_cleaner.clean(msg.backtrace).join("\n"))
      ExceptionNotifier.notify_exception(msg)
    else
      Rails.logger.warn(msg)
      ExceptionNotifier.notify_exception(RuntimeError.new(msg))
    end
  end
  def log_and_notify(msg) self.class.log_and_notify(msg) end

  # Logs the execution time of the supplied block, including the supplied text in the log message
  # e.g.
  #   log_exec_time("Class.method") { class.method }
  #
  def log_exec_time(subject)
    start = Time.now
    yield
    Rails.logger.info("ExecutionTime Log: #{subject} ran in #{Time.now - start} seconds")
    return
  end
  def self.log_exec_time(subject)
    start = Time.now
    yield
    Rails.logger.info("ExecutionTime Log: #{subject} ran in #{Time.now - start} seconds")
    return
  end

  def self.left_outer_joins(table)
    joins(
      "LEFT OUTER JOIN #{table} ON #{self.model_name.singular_route_key.pluralize}.#{table.to_s.singularize}_id = #{table}.id"
    )
  end
end
