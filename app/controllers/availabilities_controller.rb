class AvailabilitiesController < ApplicationController
  before_action :find_availability, only: [:edit, :update, :destroy]

  def index
    @availabilities = Availability.all
    @services = Service.all
    @staffs = Staff.all
  end

  def new
    debugger
    @availability = Availability.new
  end

  def edit
  end

  def create
    @availability = Availability.new(availability_params)

    @availability.save
    redirect_to availabilities_path
    
  end

  def destroy
    @availability.delete
    redirect_to availabilities_path
  end

  def update
    @availability.update(availability_params)
    redirect_to availabilities_path
  end

  private

  def find_availability
    @availability = Availability.find(params[:id])
  end

  def availability_params
    params.require(:availability)
      .permit(:service_id, :staff_id, :start_time, :end_time, :start_date, :end_date)
  end
end
