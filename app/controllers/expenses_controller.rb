class ExpensesController < ApplicationController

  def index
  end

  def new
    @expense = Expense.new
  end
end
