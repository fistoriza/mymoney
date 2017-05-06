class ExpensesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  
  def index
  end

  def new
    @expense = Expense.new
  end

  def create
    @expense = current_user.expenses.create(expense_params)
    if @expense.valid?
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def expense_params
    params.require(:expense).permit(:entry, :amount)
  end
end
