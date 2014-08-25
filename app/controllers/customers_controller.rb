class CustomersController < ApplicationController
  before_action :find_customer, only: [ :edit, :update, :destroy ]

  def index

    @customers = Customer.all
  end

  def new

    @customer = Customer.new
  end

  def edit
  end

  def create

    @customer = Customer.new(customer_params)
    @customer.save
    redirect_to customers_path
  end

  def destroy

    @customer.delete
    redirect_to customers_path
  end

  def update

    @customer.update(customer_params)
    redirect_to customers_path
  end

  def search

    if params[:customer]
      @found_customer = Customer.where(phone_number: params[:customer][:phone_number]).first
    else
      @found_customer = nil
    end
  end

  private

  def find_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    
    params.require(:customer)
      .permit(:name, :address, :phone_number, :email)
  end
end
