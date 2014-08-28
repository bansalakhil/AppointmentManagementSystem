class ServicesController < ApplicationController
  before_action :find_service, only: [ :edit, :update, :destroy ]
  before_action :get_all_services, only: [:index]

  def index
  end

  def new
    new_service
  end

  def edit
  end

  def create

    new_service(service_params)

    if @service.save
      flash[:notice] = 'Service successfully saved'
    else
      flash[:notice] = 'Service could not be saved'
    end
    redirect_to_path(services_path)
  end

  def destroy

    if @service.update_column('active', false) #soft delete
      flash[:notice] = 'Service sucessfully deleted'
    else
      flash[:notice] = 'Service could not be deleted'
    end
    redirect_to_path(services_path)
  end

  def update

    if @service.update(service_params)
      flash[:notice] = 'Service sucessfully updated'
    else
      flash[:notice] = 'Service could not be updated'
    end
    redirect_to_path(services_path)
  end

  private

  def find_service
    @service = Service.find(params[:id])
  end

  def service_params
    params.require(:service).permit(:name, :slot_window)
  end

  def get_all_services
    @services = Service.where(true)
  end

  def new_service(params = nil)
    @service = Service.new(params)
  end
end
