class Admin::CustomersController < Admin::BaseController
  before_action :find_customer, only: [ :edit, :update, :destroy ]
  before_action :get_all_customers, only: [:index]

  def index
  end

  def new
    @customer = Customer.new
  end

  def edit
  end

  def create

    @customer = Customer.new(customer_params)

    respond_to do |format|
      if @customer.save
        @customer.invite!
        format.js { render :action => "refresh" }
      else
        format.js { render :action => "new" }
      end
    end
  end

  def destroy

    if @customer.destroy
      flash[:notice] = 'Customer sucessfully deleted'
    else
      flash[:error] = 'Customer could not be deleted'
    end
    redirect_to_path(admin_customers_path)
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

  # FIX- Remove all commented code. We can always get previous versions of code from Git whenever required.
  # def search

  #   if params[:customer]
  #     @found_customer = Customer.where(phone_number: params[:customer][:phone_number]).first
  #   else
  #     @found_customer = nil
  #   end
  # end

  private

  def find_customer

    @customer = Customer.where(id: params[:id]).first

    if @customer
      return @customer
    else
      flash[:error] = 'Customer not found'
    end
  end

  def customer_params
    params.require(:customer)
      .permit(:name, :email)
  end

  def get_all_customers
    @customers = Customer.all.paginate :page => params[:page], :per_page => 5
  end

end
