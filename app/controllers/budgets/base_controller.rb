module Budgets
  class BaseController < ApplicationController

    def check_account(account)
      return if @account && account.user == current_user
      flash[:notice] = "Can't find account."
      redirect_to budgets_accounts_path
      return
    end

    def self.extract_filter_params(*args)
      options = args.extract_options!
      key_prefix = options.delete(:key_prefix)
      model_name = controller_name.sub(/Controller$/, '').singularize.underscore
      before_filter options do |controller|
        key_prefix ||= ((controller.action_name == "index") ?  model_name.pluralize : "#{controller.action_name}_#{model_name}")
        if params[:filter]
          filter_names = args.dup
          while filter_name = filter_names.shift
            if params[:filter][filter_name] && params[:filter][filter_name] != session[:"#{key_prefix}_#{filter_name}_filter"]
              filter_names.each do |a|
                session.delete(:"#{key_prefix}_#{a}_filter")
              end
              session[:"#{key_prefix}_#{filter_name}_filter"] = params[:filter][filter_name]
            end
          end
        end
      end
    end
  end
end