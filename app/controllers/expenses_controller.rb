class ExpensesController < ApplicationController
  def index
  end

  def new
    @expense = Expense.new
  end

  def create
    @expense = Expense.create(expense_params)
    redirect_to root_path
  end

  private

  def expense_params
    params.require(:expense).permit(:entry, :amount)
  end
end
