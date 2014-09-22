class Admin::StaffsController < Admin::BaseController

  PERMITTED_ATTRS = [:name, :email, :phone_number, { service_ids: [] }]
  before_action :get_staff_member, only: [:edit, :update, :destroy, :enable]
  before_action :get_all_staffs, only: [:index]
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
        flash[:notice] = "#{@staff.name.capitalize} is sucessfully added to our team"
        format.js { render action: 'refresh' }
      else
        flash.now[:error] = 'Staff could not be added'
        format.js do
          render action: 'new'
        end
      end
    end
  end

  def update
    respond_to do |format|
      if @staff.update(staff_params)
        flash.now[:notice] = "Record for #{@staff.name.capitalize} is sucessfully updated"
        format.js { render action: 'refresh' }
      else
        flash.now[:error] = "Record for #{@staff.name.capitalize} could not be updated"
        format.js do
          get_all_services
          render action: 'edit'
        end
      end
    end
  end

  def destroy

    if @staff.destroy
      flash[:notice] = "#{@staff.name.capitalize} is sucessfully disabled "
    else
      flash[:error] = "#{@staff.name.capitalize} could not be disabled"
    end
    redirect_to admin_staffs_path
  end

  def enable
    @staff.restore
    flash[:notice] = "#{@staff.name.capitalize} is ready to provide availability "
    redirect_to admin_staffs_path
  end

  private

  def get_staff_member

    @staff = Staff.with_deleted.where(id: params[:id]).first

    if @staff
      return @staff
    else
      flash[:error] = 'Staff member not found'
    end
  end

  def staff_params
    params.require(:staff).permit(*PERMITTED_ATTRS)
  end

  def get_all_staffs
    @staffs = Staff.with_deleted.paginate :page => params[:page], :per_page => 10
  end

  def get_all_services
    @services = Service.all
  end

end
