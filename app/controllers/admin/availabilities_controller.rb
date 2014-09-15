class Admin::AvailabilitiesController < Admin::BaseController

  PERMITTED_ATTRS = [:service_id, :staff_id, :start_time, :end_time, :start_date, :end_date]
  before_action :get_availability, only: [:edit, :update, :destroy, :enable]
  before_action :get_services, only: [:new, :edit]
  before_action :get_all_availabilities, only: [:index]

  def index
  end

  def new
    @availability = Availability.new
  end

  def edit
    @staff = @availability.service.staffs
  end

  def create

    @availability = Availability.new(availability_params)

    if @availability.save
      render 'refresh'
    else
      get_services
      @staff = @availability.service.staffs
      render action: 'new'
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
    if @availability.update(availability_params)
      render 'refresh'
    else
      format.js do
        render 'edit'
      end
    end
  end

  def enable
    @availability.restore
    redirect_to_path(admin_availabilities_path)
  end

  #method fetches all the staff corresponding to a service
  def get_staff
    respond_to do |format|
      format.js do
        @staffs = Service.where(id: params[:service_id]).first.staffs
        render json: @staffs
      end
    end
  end

  private

  def get_availability
    @availability = Availability.with_deleted.where(id: params.require(:id)).first

    @availability ||= (flash[:error] = 'Availability not found')
  end

  def availability_params
    params.require(:availability)
      .permit(*PERMITTED_ATTRS)
  end

  def get_services
    @services = Service.all
  end

  def get_all_availabilities
    @availabilities = Availability.all.paginate page: params[:page], per_page: 5
  end
end
