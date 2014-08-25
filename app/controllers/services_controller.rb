class ServicesController < ApplicationController
  before_action :find_service, only: [ :edit, :update, :destroy ]

  def index

    @services = Service.all
  end

  def new

    @service = Service.new
  end

  def create

    @service = Service.new(service_params)
    @service.save
    redirect_to services_path
  end

  def destroy

    @service.update_column(active, false) #soft delete
    redirect_to services_path
  end

  def update

    @service.update(service_params)
    redirect_to services_path
  end

  def edit
  end

  private

  def find_service
    @service = Service.find(params[:id])
  end

  def service_params
    params.require(:service).permit(:name, :slot_window)
  end
end
