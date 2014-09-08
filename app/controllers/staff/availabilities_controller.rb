class Staff::AvailabilitiesController < Staff::BaseController
  before_action :find_availability, only: [:edit, :update, :destroy]
  before_action :get_services_staffs, only: [:index, :new, :edit]
  before_action :get_all_availabilities, only: [:index]

  def index
  end

  def new
    new_availability
  end

  def edit
  end

  def create

    new_availability(availability_params)
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
      flash[:notice] = 'Availability could not be deleted'
    end
    redirect_to_path(staff_availabilities_path)
  end

  def update

    respond_to do |format|
      if @availability.update(availability_params)
        format.js { render action: 'refresh' }
      else
        format.js do
          get_services_staffs
          render :action => "edit"
        end
      end
    end
  end

  def serving_staff #call it after ajax
    respond_to do |format|
      format.js do
        @people = Service.where(id: params[:service_id]).first.staffs
        render json: @people
      end
    end
  end

  private

  def find_availability
    @availability = Availability.where(id: params[:id]).first
  end

  def availability_params
    params.require(:availability)
      .permit(:service_id, :staff_id, :start_time, :end_time, :start_date, :end_date)
  end

  def new_availability(params = nil)
    @availability = Availability.new(params)
  end

  def get_services_staffs
    @services = Service.all
    @staffs = Staff.all
  end

  def get_all_availabilities
    @availabilities = Availability.where(true)
  end
end
