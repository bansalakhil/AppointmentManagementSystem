class Admin::ServicesController < Admin::BaseController
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

    respond_to do |format|
      if @service.save
        format.js { render action: 'refresh' }
      else
        format.js { render action: 'new' }
      end
    end
  end

  def destroy

    if @service.update_column('active', false) #soft delete
      flash[:notice] = 'Service sucessfully deleted'
    else
      flash[:notice] = 'Service could not be deleted'
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

  private

  def find_service
    @service = Service.find(params[:id])
  end

  def service_params
    params.require(:service).permit(:name, :slot_window)
  end

  def get_all_services
    @services = Service.all
  end

  def new_service(params = nil)
    @service = Service.new(params)
  end
end