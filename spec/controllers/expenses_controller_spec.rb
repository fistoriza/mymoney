require 'rails_helper'

RSpec.describe ExpensesController, type: :controller do
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
      user = User.create(
        email:                     'fakeuser@gmail.com', 
        password:                  'secretPassword',
        password_confirmation:     'secretPassword' 
      )
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
      user = User.create(
        email:                     'fakeuser@gmail.com', 
        password:                  'secretPassword',
        password_confirmation:     'secretPassword' 
      )
      sign_in user

      post :create, params: { expense: { entry: 'Food!' } }
      expect(response).to redirect_to root_path

      expense = Expense.last
      expect(expense.entry).to eq('Food!')
      expect(expense.user).to eq(user)
    end

    it "should properly deal with validation errors" do
      user = User.create(
        email:                     'fakeuser@gmail.com', 
        password:                  'secretPassword',
        password_confirmation:     'secretPassword' 
      )
      sign_in user

      post :create, params: { expense: { entry: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(Expense.count).to eq 0
    end
  end
end
