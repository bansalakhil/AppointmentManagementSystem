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

    respond_to do |format|
      if @customer.save
        @customer.invite!
        format.js { render :action => "refresh" }
      else
        format.js { render :action => "edit" }
      end
    end
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

    respond_to do |format|
      if @customer.update(customer_params)
        format.js { render :action => "refresh" }
      else
        format.js { render :action => "edit" }
      end
    end
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
    @customer = Customer.where(id: params[:id]).first
  end

  def customer_params
    params.require(:customer)
      .permit(:name, :phone_number, :email)
  end

  def get_all_customers
    @customers = Customer.where(true)
  end

  def new_customer(params = nil)
    @customer = Customer.new(params)
  end
end
