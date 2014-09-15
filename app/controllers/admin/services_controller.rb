class Admin::ServicesController < Admin::BaseController

  PERMITTED_ATTRS = [:name, :slot_window]
  before_action :get_service, only: [ :edit, :update, :destroy, :enable ]
  before_action :get_all_services, only: [:index]

  def index
  end

  def new
    @service = Service.new
  end

  def edit
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

    if @service.destroy
      flash[:notice] = 'Service sucessfully deleted'
    else
      flash[:error] = 'Service could not be deleted'
    end
    redirect_to_path(admin_services_path)
  end

  def update
    respond_to do |format|
      if @service.update(service_params)
        format.js { render action: 'refresh' }
      else
        format.js { render action: 'edit' }
      end
    end
  end

  def enable
    @service.restore
    redirect_to_path(admin_services_path)
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
    @services = Service.with_deleted.order(deleted_at: :desc).paginate page: params[:page], per_page: 3
    @deleted, @non_deleted =  @services.partition { |serv|  serv.deleted? }
  end

end
