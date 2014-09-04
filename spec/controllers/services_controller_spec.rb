require 'rails_helper'

RSpec.describe ServicesController, :type => :controller do


  it "blocks unauthenticated access" do
    sign_in nil

    get :index

    response.should redirect_to(root_path)
  end

  it do
    sign_in

    # post :create
    should permit(:name, :slot_window).for(:create), format: :js
  end

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

    xhr :post, :create, {service: {name: 'service_one', slot_window: 30}}
    should render_template('refresh')
  end

  # it 'PUT #update' do
  #   sign_in

  #   xhr :put, :update, {service: {name: 'service_one', slot_window: 30}}
  #   should render_template('refresh')
  # end

  # it 'POST #create' do
  #   sign_in

  #   xhr :post, :create, {service: {name: 'service_one', slot_window: 30}}
  #   should render_template('update')
  # end
end