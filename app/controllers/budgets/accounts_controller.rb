module Budgets
  class AccountsController < BaseController
    before_action :set_back, only: [:new, :edit]
    extract_filter_params :search_start_date, :search_end_date, :only => :index
    before_action :setup
    skip_before_action :verify_authenticity_token

    def show
    end

    def index
      @accounts = current_user.accounts.all
    end

    def new
      @account = Budgets::Account.new()
    end

    def create
      @account = current_user.accounts.new(account_params)
      if @account.save
        if @account.opening_balance >= 0
          transaction_type = 1
          amount = @account.opening_balance
        else
          transaction_type = 2
          amount = -@account.opening_balance
        end

        @account.transactions.create(transaction_date: @account.start_date,
                    amount: amount,
                    transaction_type: transaction_type,
                    details: "Opening Balance",
                    particulars: "Opening Balance",
                    sort_order: 1
                  )

        flash[:notice] = "Successfully created account."
        redirect_to session[:budgets_return_to] || @account
      else
        flash.now[:alert] = @account.errors if @account.errors.any?
        render :new
      end
    end

    def update
      if @account.update(account_params)
        flash[:notice] = "Successfully updated account."
        redirect_to session[:budgets_return_to] || @account
      else
        flash.now[:alert] = @account.errors if @account.errors.any?
        render :edit
      end
    end

    def destroy
      @account.destroy
      flash[:notice] = "Successfully destroyed account."
      redirect_to session[:budgets_return_to] || budgets_accounts_path
    end

    def transaction_search
      @transactions = @account.transactions.where("transaction_date BETWEEN ? AND ?", @search_start_date, @search_end_date)
    end

    private
      def set_back
        session[:budgets_return_to] = request.referer
      end

      def setup
        if params[:id]
          @account = current_user.accounts.find_by_id(params[:id])
          check_account(@account)
        end

        case action_name
        when 'index'
          @buttons = %i(new)
        when 'new','create'
          @buttons = %i(save cancel)
        when 'edit','update'
          @buttons = %i(save cancel)
        when 'show'
          @buttons = %i(new edit delete)
        end

        @new_text = "New Account"
        @new_path = new_budgets_account_path
        @save_path = budgets_account_path(@account) if @account.present?
        @delete_path = budgets_account_path(@account) if @account.present?
        @edit_path = edit_budgets_account_path(@account) if @account.present?

        @active_tab = 'details'
      end

      def account_params
        params.require(:budgets_account).permit(Budgets::Account.permitted_attributes)
      end
  end
end