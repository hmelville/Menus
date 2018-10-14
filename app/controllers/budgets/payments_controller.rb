module Budgets
  class PaymentsController < BaseController
    # extract_filter_params :search_start_date, :search_end_date, :only => :index
    before_action :setup
    skip_before_action :verify_authenticity_token

    def index
      @payments = @account.payments.all
    end

    def new
      @payment = Budgets::Account.new()
    end

    def create
      @payment = @account.payments.new(payment_params)
      if @payment.save
        flash[:notice] = "Successfully created payment."
        redirect_to @payment
      else
        flash.now[:alert] = @payment.errors if @payment.errors.any?
        render :new
      end
    end

    def update
      if @payment.update(payment_params)
        flash[:notice] = "Successfully updated payment."
        redirect_to @payment
      else
        flash.now[:alert] = @payment.errors if @payment.errors.any?
        render :edit
      end
    end

    def destroy
      @payment.destroy
      flash[:notice] = "Successfully destroyed payment."
      redirect_to budgets_payments_path
    end

    private
      def setup
        @account = current_user.accounts.find_by_id(params[:account_id])
        check_account(@account)

        if params[:id]
          @account = @account.payments.find_by_id(params[:id])
        end

        case action_name
        when 'index'
          @buttons = %i(new)
        when 'new','create'
          @buttons = %i(save cancel)
        when 'edit','update'
          @buttons = %i(save cancel delete)
        end

        @new_text = "New Payment"
        @save_path = budgets_account_path(@account)
        @new_path = new_budgets_account_payment_path(@account)
        @edit_path = edit_budgets_account_payment_path(@account, @payment) if @payment.present?
        @delete_path = budgets_account_payment_path(@account, @payment) if @payment.present?

        @active_tab = 'payments'
      end

      def payment_params
        params.require(:budgets_payment).permit(Budgets::Payment.permitted_attributes)
      end
  end
end