module FoodMenus
  class BaseController < ApplicationController

    rescue_from CanCan::AccessDenied do |exception|
      logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
      render "/pages/not_authorised", locals: {exception: exception}
    end

    rescue_from ActiveRecord::RecordNotFound do |exception|
      logger.debug "Record Not Found error #{exception}"
      render "/pages/not_found", locals: {exception: "Oops we couldn't find what you were looking for!"}
    end
  end
end