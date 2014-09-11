class Admin::AvailabilitiesController < Admin::BaseController
  # NOTE- Please make sure that all the fixes mentioned in CR, should apply everywhere.

  # FIX- Maintain consitency in naming before_actions. Please use load_*, fetch_*, or find_* everywhere.
  before_action :find_availability, only: [:edit, :update, :destroy]
  # Call private methods from inside actions when you are only loading data in them
  before_action :get_services_staffs, only: [:index, :new, :edit]
  before_action :get_all_availabilities, only: [:index]

  def index
  end

  def new
    # FIX- No need to call #new_availability. Initialize availability here only.
    new_availability
  end

  def edit
  end

  def create
    # FIX- Initialize here. Remove next line.
    new_availability(availability_params)

    # FIX- We can skip respond_to block if there is only one type of request expected
    respond_to do |format|
      if @availability.save
        format.js { render action: 'refresh' }
      else
        format.js do
          get_services_staffs
          render action: 'new'
        end
      end
    end
  end

  def destroy
    if @availability.destroy
      flash[:notice] = 'Availability sucessfully deleted'
    else
      # FIX- It is an error, not notice.
      flash[:notice] = 'Availability could not be deleted'
    end
    redirect_to_path(admin_availabilities_path)
  end

  def update
    # FIX- Remove respond_to.
    respond_to do |format|
      if @availability.update(availability_params)
        format.js { render action: 'refresh' }
      else
        format.js do
          get_services_staffs
          # FIX- Use new syntax for hash.
          render :action => "edit"
        end
      end
    end
  end

  # FIX- Find some other name
  def serving_staff #call it after ajax
    # FIX- Remove respond_to.    
    respond_to do |format|
      format.js do
        # FIX- @staffs would be a better name.
        # FIX- Use strong parameters.
        @people = Service.where(id: params[:service_id]).first.staffs
        render json: @people
      end
    end
  end

  private

  def find_availability
    # FIX- Handle case when availability could not be found
    # FIX- Use params.require(:id) instead of params[:id]
    @availability = Availability.where(id: params[:id]).first
  end

  def availability_params
    params.require(:availability)
      .permit(:service_id, :staff_id, :start_time, :end_time, :start_date, :end_date)
  end

  # Remove
  def new_availability(params = nil)
    @availability = Availability.new(params)
  end

  # FIX- Make names consistent
  def get_services_staffs
    @services = Service.all
    @staffs = Staff.all
  end

  # FIX- Make names consistent
  def get_all_availabilities
    # Use #all
    @availabilities = Availability.where(true)
  end
end
