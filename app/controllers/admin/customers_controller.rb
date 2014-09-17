class Admin::CustomersController < Admin::BaseController
  PERMITTED_ATTRS = [:name, :email, :phone_number]
  before_action :find_customer, only: [ :edit, :update, :destroy, :enable ]
  before_action :get_all_customers, only: [:index]

  def index
  end

  def edit
  end

  def destroy

    if @customer.destroy
      flash[:notice] = 'Customer sucessfully deleted'
    else
      flash[:error] = 'Customer could not be deleted'
    end
    redirect_to admin_customers_path
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

  def enable
    @customer.restore
    redirect_to admin_customers_path
  end

  private

  def find_customer

    @customer = Customer.with_deleted.where(id: params[:id]).first

    if @customer
      return @customer
    else
      flash[:error] = 'Customer not found'
    end
  end

  def customer_params
    params.require(:customer)
      .permit(*PERMITTED_ATTRS)
  end

  def get_all_customers
    @customers = Customer.with_deleted.paginate :page => params[:page], :per_page => 10
  end

end
