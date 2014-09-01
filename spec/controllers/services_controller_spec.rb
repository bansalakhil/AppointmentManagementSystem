require 'rails_helper'

RSpec.describe ServicesController, :type => :controller do


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

  # it 'GET #new' do
  #   sign_in

  #   get :new, :format => :js
  #   should render_template(partial: 'form')
  # end

  it 'POST #create' do

  end
end