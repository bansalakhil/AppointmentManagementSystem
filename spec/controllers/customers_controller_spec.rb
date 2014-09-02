require 'rails_helper'

RSpec.describe CustomersController, :type => :controller do


  it "blocks unauthenticated access" do
    sign_in nil

    get :index

    response.should redirect_to(root_path)
  end

  # it do
  #   sign_in

  #   post :create
  #   should permit(:name, :slot_window)
  # end

  it 'GET #index' do
    sign_in

    get :index
    should respond_with(200)
  end

  it 'GET #new' do
    sign_in

    xhr :get, :new, format: :js
    should render_template('new')
  end

  it 'POST #create' do
    sign_in

    xhr :post, :create, { customer: { name: 'customer_one', phone_number: '54365436345', email: 'a@a.com' } }
    should render_template('update')
  end

  # it 'PUT #update' do
  #   sign_in

  #   xhr :patch, :update, {staff: {name: 'service_two', phone_number: '54365436345', email: 'a@a.com'}}
  #   should render_template('update')
  # end

  # it 'DELETE #destroy' do
  #   sign_in

  #   delete :destroy
  #   should respond_with(200)
  # end

end