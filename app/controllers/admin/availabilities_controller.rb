class Admin::AvailabilitiesController < Admin::BaseController
  before_action :get_availability, only: [:edit, :update, :destroy]
  before_action :get_services_staffs, only: [:index, :new, :edit]
  before_action :get_all_availabilities, only: [:index]

  def index
  end

  def new
    @availability = Availability.new
  end

  def edit
  end

  def create

    @availability = Availability.new(availability_params)

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
      flash[:error] = 'Availability could not be deleted'
    end
    redirect_to_path(admin_availabilities_path)
  end

  def update

    respond_to do |format|
      if @availability.update(availability_params)
        render js: { action: 'refresh' }
      else
        format.js do
          get_services_staffs
          render action: "edit"
        end
      end
    end
  end

  #method fetches all the staff corresponding to a service
  def serving_staff
    respond_to do |format|
      format.js do
        @staffs = Service.where(id: params[:service_id]).first.staffs
        render json: @staffs
      end
    end
  end

  private

  def get_availability
    # FIX- Use params.require(:id) instead of params[:id]
    @availability = Availability.where(id: params[:id]).first

    if @availability
      return @availability
    else
      flash[:error] = 'Availability not found'
    end
  end

  def availability_params
    params.require(:availability)
      .permit(:service_id, :staff_id, :start_time, :end_time, :start_date, :end_date)
  end

  def get_services_staffs
    @services = Service.all
    @staffs = Staff.all
  end

  def get_all_availabilities
    @availabilities = Availability.all.paginate :page => params[:page], :per_page => 5
  end
end
