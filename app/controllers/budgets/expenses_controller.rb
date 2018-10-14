module Budgets
  class ExpensesController < BaseController
    before_action :set_back, only: [:new, :edit]
    before_action :setup
    skip_before_action :verify_authenticity_token

    def index
      @expenses = @account.expenses.all
    end

    def new
      @expense = Budgets::Expense.new()
    end

    def create
      @expense = @account.expenses.new(expense_params)
      if @expense.save
        flash[:notice] = "Successfully created expense."
        redirect_to @expense
      else
        flash.now[:alert] = @expense.errors if @expense.errors.any?
        render :new
      end
    end

    def update
      byebug
      if @expense.update(expense_params)
        flash[:notice] = "Successfully updated expense."
        redirect_to @expense
      else
        flash.now[:alert] = @expense.errors if @expense.errors.any?
        render :edit
      end
    end

    def destroy
      @expense.destroy
      flash[:notice] = "Successfully destroyed expense."
      redirect_to budgets_account_expenses_path(@account)
    end

    private
      def set_back
        session[:budgets_return_to] = request.referer
      end

      def setup
        @account = current_user.accounts.find_by_id(params[:account_id])
        check_account(@account)

        if params[:id]
          @expense = @account.expenses.find_by_id(params[:id])
        end

        case action_name
        when 'index'
          @buttons = %i(new)
        when 'new','create'
          @buttons = %i(save cancel)
        when 'edit','update'
          @buttons = %i(save cancel delete)
        end

        @new_text = "New Expense"
        @save_path = budgets_account_path(@account)
        @new_path = new_budgets_account_expense_path(@account)
        @edit_path = edit_budgets_account_expense_path(@account, @expense) if @expense.present?
        @delete_path = budgets_account_expense_path(@account, @expense) if @expense.present?

        @active_tab = 'expenses'
      end

      def expense_params
        params.require(:budgets_expense).permit(Budgets::Expense.permitted_attributes)
      end
  end
end