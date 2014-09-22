class Admin::ServicesController < Admin::BaseController

  PERMITTED_ATTRS = [:name, :slot_window]
  before_action :get_service, only: [:destroy, :enable]
  before_action :get_all_services, only: [:index]

  def index
  end

  def new
    @service = Service.new
  end

  def create

    @service = Service.new(service_params)

    respond_to do |format|
      if @service.save
        format.js { render action: 'refresh' }
      else
        format.js { render action: 'new' }
      end
    end
  end

  def destroy

    #if service has any appointment then just disable otherwise really_destroy!
    if @service.appointments.first
      if @service.destroy
        flash[:notice] = 'Service sucessfully disabled. You can now remove its corresponding appointments'
      else
        flash[:error] = 'Service could not be disabled. you have appointments for this service'
      end
    else
      if @service.really_destroy!
        flash[:notice] = 'Service sucessfully permanently deleted'
      else
        flash[:error] = 'Service could not be deleted'
      end
    end

    redirect_to admin_services_path
  end

  def enable
    @service.restore
    flash[:notice] = 'Service is successfully enabled. New appointments for this service can now be created'
    redirect_to admin_services_path
  end

  private

  def get_service
    @service = Service.with_deleted.where(id: params[:id]).first

    if @service
      return @service
    else
      flash[:error] = 'Service not found'
    end
  end

  def service_params
    params.require(:service).permit(*PERMITTED_ATTRS)
  end

  def get_all_services
    @services = Service.with_deleted.paginate page: params[:page], per_page: 10
  end

end
