class CustomersController < ApplicationController
  before_action :find_customer, only: [ :edit, :update, :destroy ]
  before_action :get_all_customers, only: [:index]

  def index
  end

  def new
    new_customer
  end

  def edit
  end

  def create

    new_customer(customer_params)

    if @customer.save
      flash[:notice] = 'Customer successfully saved'
    else
      flash[:notice] = 'Customer could not be saved'
    end
    redirect_to_path(customers_path)
  end

  def destroy

    if @customer.destroy
      flash[:notice] = 'Customer sucessfully deleted'
    else
      flash[:notice] = 'Customer could not be deleted'
    end
    redirect_to_path(customers_path)
  end

  def update

    if @customer.update(customer_params)
      flash[:notice] = 'Customer sucessfully updated'
    else
      flash[:notice] = 'Customer could not be updated'
    end
    redirect_to_path(customers_path)
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

  def get_all_customers
    @customers = Customer.where(true)
  end

  def new_customer(params = nil)
    @customer = Customer.new(params)
  end
end
