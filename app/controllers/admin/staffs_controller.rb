class Admin::StaffsController < Admin::BaseController

  PERMITTED_ATTRS = [:name, :email, :phone_number, { service_ids: [] }] 
  before_action :get_staff_member, only: [ :edit, :update, :destroy, :deactivate ]
  before_action :get_all_staffs, only: [ :index ]
  before_action :get_all_services, only: [:create, :new, :update, :edit]

  def index
  end

  def new
    @staff = Staff.new
  end

  def edit
  end

  def create

    @staff = Staff.new(staff_params)

    respond_to do |format|
      if @staff.save
        @staff.invite!
        flash[:notice] = 'Staff sucessfully created'
        format.js { render action: 'refresh' }
      else
        flash.now[:error] = 'Staff could not be created'
        format.js do
          render action: 'new'
        end
      end
    end
  end

  def update

    respond_to do |format|
      if @staff.update_attributes(staff_params)
        flash[:notice] = 'Staff sucessfully updated'
        format.js { render action: 'refresh' }
      else
        flash.now[:error] = 'Staff could not be updated'
        format.js do
          get_all_services
          render action: 'edit'
        end
      end
    end
  end

  def destroy

    if @staff.destroy
      flash[:notice] = 'Staff sucessfully deleted'
    else
      flash[:error] = 'Staff could not be deleted'
    end
    redirect_to_path(admin_staffs_path)
  end

  def deactivate
    @staff.update_attributes({ active: false, deleted_at: Time.now })
    flash[:notice] = 'Staff sucessfully deleted'
    redirect_to_path(admin_staffs_path)
  end

  private

  def get_staff_member

    @staff = Staff.where(id: params[:id]).first

    if @staff
      return @staff
    else
      flash[:error] = 'Staff member not found'
    end
  end

  def staff_params

    params.require(:staff)
      .permit(*PERMITTED_ATTRS)
  end

  def get_all_staffs
    @staffs = Staff.all.paginate :page => params[:page], :per_page => 5
  end

  def get_all_services
    @services = Service.where(true)
  end

end
