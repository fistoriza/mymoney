class ExpensesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
  end

  def new
    @expense = Expense.new
  end

  def destroy
    @expense = Expense.find_by_id(params[:id])
    return render_not_found if @expense.blank?

    @expense.destroy
    redirect_to root_path
  end

  def edit
    @expense = Expense.find_by_id(params[:id])
    if @expense.blank?
      render_not_found
    end
  end

  def update
    @expense = Expense.find_by_id(params[:id])
    return render_not_found if @expense.blank?

    @expense.update_attributes(expense_params)

    if @expense.valid?
      redirect_to root_path
    else
      return render :edit, status: :unprocessable_entity
    end
  end

  def show
    @expense = Expense.find_by_id(params[:id])
    if @expense.blank?
      render_not_found
    end
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

  def render_not_found
    render plain: 'Not Found', status: :not_found
  end
end
