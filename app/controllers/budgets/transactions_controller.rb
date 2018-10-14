module Budgets
  class TransactionsController < BaseController
    before_action :set_back, only: [:new, :edit]
    extract_filter_params :search_start_date, :search_end_date, :only => :index
    before_action :setup
    skip_before_action :verify_authenticity_token

    def index
      @search_start_date = session[:transactions_search_start_date_filter] || Date.today.beginning_of_month
      @search_end_date = session[:transactions_search_end_date_filter] || Date.today
      @transactions = @account.transactions_by_date(@search_start_date, @search_end_date)
    end

    def new
      @transaction = Budgets::Transaction.new()
    end

    def create
      @transaction = @account.transactions.new(transaction_params)
      if @transaction.save
        flash[:notice] = "Successfully created transaction."
        redirect_to @transaction
      else
        flash.now[:alert] = @transaction.errors if @transaction.errors.any?
        render :new
      end
    end

    def update
      byebug
      if @transaction.update(transaction_params)
        flash[:notice] = "Successfully updated transaction."
        redirect_to @transaction
      else
        flash.now[:alert] = @transaction.errors if @transaction.errors.any?
        render :edit
      end
    end

    def destroy
      @transaction.destroy
      flash[:notice] = "Successfully destroyed transaction."
      redirect_to budgets_account_transactions_path(@account)
    end

    private
      def set_back
        session[:budgets_return_to] = request.referer
      end

      def setup
        @account = current_user.accounts.find_by_id(params[:account_id])
        check_account(@account)

        if params[:id]
          @transaction = @account.transactions.find_by_id(params[:id])
        end

        case action_name
        when 'index'
          @buttons = %i(new)
        when 'new','create'
          @buttons = %i(save cancel)
        when 'edit','update'
          @buttons = %i(save cancel delete)
        end

        @new_text = "New Transaction"
        @save_path = budgets_account_path(@account)
        @new_path = new_budgets_account_transaction_path(@account)
        @edit_path = edit_budgets_account_transaction_path(@account, @transaction) if @transaction.present?
        @delete_path = budgets_account_transaction_path(@account, @transaction) if @transaction.present?

        @active_tab = 'transactions'
      end

      def transaction_params
        params.require(:budgets_transaction).permit(Budgets::Transaction.permitted_attributes)
      end
  end
end