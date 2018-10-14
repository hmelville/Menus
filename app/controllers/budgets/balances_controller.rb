module Budgets
  class BalancesController < BaseController
    before_action :setup
    skip_before_action :verify_authenticity_token

    def index
    end

    private
      def setup
        if params[:account_id]
          @account = current_user.accounts.find_by_id(params[:account_id])

          check_account(@account)
        end

        case action_name
        when 'index'
          @page_heading = "Balances"
          @buttons = %i(edit delete)
        end

        @active_tab = 'balances'
      end
  end
end