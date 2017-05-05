require 'rails_helper'

RSpec.describe ExpensesController, type: :controller do
  describe "expenses#index action" do
    it "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "expenses#new action" do
    it "should successfully show the new form" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "expenses#create action" do
    it "should successfully create a new expense in the database" do
      post :create, params: { expense: { entry: 'Food!' } }
      expect(response).to redirect_to root_path

      expense = Expense.last
      expect(expense.entry).to eq('Food!')
    end
  end
end
