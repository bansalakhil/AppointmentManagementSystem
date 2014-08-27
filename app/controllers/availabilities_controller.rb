class AvailabilitiesController < ApplicationController
  before_action :find_availability, only: [:edit, :update, :destroy]

  def index
    @availabilities = Availability.all
    @services = Service.all
    @staffs = Staff.all
  end

  def new
    @availability = Availability.new
    @services = Service.all
    @staffs = Staff.all
  end

  def edit
    # debugger
    @services = Service.all
    @staffs = Staff.all
  end

  def create
    @availability = Availability.new(availability_params)

    if @availability.save
      redirect_to availabilities_path
    else
      flash[:notice] = 'Availability could not be saved'
      redirect_to availabilities_path
    end
    
  end

  def destroy
    @availability.destroy
    redirect_to availabilities_path
  end

  def update
    if @availability.update(availability_params)
      redirect_to availabilities_path
    else
      flash[:notice] = 'Availability could not be updated'
      redirect_to availabilities_path
    end
    
  end

  private

  def find_availability
    @availability = Availability.where(params[:id]).first
  end

  def availability_params
    params.require(:availability)
      .permit(:service_id, :staff_id, :start_time, :end_time, :start_date, :end_date)
  end
end
