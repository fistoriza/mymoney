require 'rails_helper'

RSpec.describe ExpensesController, type: :controller do
  describe "expense#destroy action" do
    it "should allow a user to destroy expenses" do
      expense = FactoryGirl.create(:expense)
      delete :destroy, params: { id: expense.id }
      expect(response).to redirect_to root_path
      expense = Expense.find_by_id(expense.id)
      expect(expense).to eq nil
    end

    it "should return a 404 error if we cannot find an expense with the id that is specified" do
      delete :destroy, params: { id: 'TACOBOY' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "expense#update action" do
    it "should allow users to update expense" do
      expense = FactoryGirl.create(:expense, entry: 'Food')
      patch :update, params: { id: expense.id, expense: { entry: 'Changed' } }
      expect(response).to redirect_to root_path
      expense.reload
      expect(expense.entry).to eq 'Changed'
    end

    it "should have http 404 error if the expense cannot be found" do
      patch :update, params: { id: 'YOLOSWAG', expense: { entry: 'Changed' } }
      expect(response).to have_http_status(:not_found)
    end

    it "should render the edit form with an http status of unprocessable_entity" do
      expense = FactoryGirl.create(:expense, entry: 'Food')
      patch :update, params: { id: expense.id, expense: { entry: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expense.reload
      expect(expense.entry).to eq 'Food'
    end
  end

  describe "expenses#edit action" do
    it "should successfully show the edit form if the expense is found" do
      expense = FactoryGirl.create(:expense)
      get :edit, params: { id: expense.id }
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error message if the expense is not found" do
      get :edit, params: { id: 'TACOCAT' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "expenses#show action" do
    it "should successfully show the page if the expense is found" do
      expense = FactoryGirl.create(:expense)
      get :show, params: { id: expense.id }
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error if the expense is not found" do
      get :show, params: { id: 'TACOCAT' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "expenses#index action" do
    it "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "expenses#new action" do
    it "should require users to be logged in" do
      get :new
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully show the new form" do
      user = FactoryGirl.create(:user)
      sign_in user

      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "expenses#create action" do
    it "should require users to be logged in" do
      post :create, params: { expense: { entry: "Food" } }
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully create a new expense in the database" do
      user = FactoryGirl.create(:user)
      sign_in user

      post :create, params: { expense: { entry: 'Food!' } }
      expect(response).to redirect_to root_path

      expense = Expense.last
      expect(expense.entry).to eq('Food!')
      expect(expense.user).to eq(user)
    end

    it "should properly deal with validation errors" do
      user = FactoryGirl.create(:user)
      sign_in user

      post :create, params: { expense: { entry: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(Expense.count).to eq 0
    end
  end
end
