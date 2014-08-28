class AvailabilitiesController < ApplicationController
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

    if @availability.save
      flash[:notice] = 'Availability successfully saved'
    else
      flash[:notice] = 'Availability could not be saved'
    end
    redirect_to_path(availabilities_path)
    
  end

  def destroy

    if @availability.destroy
      flash[:notice] = 'Availability sucessfully deleted'
    else
      flash[:notice] = 'Availability could not be deleted'
    end
    redirect_to_path(availabilities_path)
  end

  def update

    if @availability.update(availability_params)
      flash[:notice] = 'Availability sucessfully updated'
    else
      flash[:notice] = 'Availability could not be updated'
    end
    redirect_to_path(availabilities_path)
  end

  private

  def find_availability
    @availability = Availability.where(params[:id]).first
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
