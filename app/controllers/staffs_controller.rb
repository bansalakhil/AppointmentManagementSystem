class StaffsController < ApplicationController
  before_action :find_staff_member, only: [ :edit, :update, :destroy, :disable ]
  before_action :get_all_staffs, only: [ :index ]
  before_action :get_all_services, only: [:create, :new, :update, :edit]

  def index
  end

  def new
    new_staff
    get_all_services
  end

  def edit
  end

  def create

    new_staff(staff_params)

    respond_to do |format|
      if @staff.save
        format.js { render action: 'update' }
      else
        format.js do
          get_all_services
          render action: 'edit'
        end
      end
    end
  end

  def update

    respond_to do |format|
      if @staff.update(staff_params)
        format.js { render action: 'update' }
      else
        format.js do
          get_all_services
          render action: 'edit'
        end
      end
    end
  end

  def destroy
    if @staff.destroy
      # @staff.availability
      flash[:notice] = 'Staff sucessfully deleted'
    else
      flash[:notice] = 'Staff could not be deleted'
    end
    redirect_to_path(staffs_path)
  end

  def deactivate
    @staff.update_attribute('active', false)
    redirect_to_path(staffs_path)
  end

  private

  def find_staff_member
    @staff = Staff.where(id: params[:id]).first
  end

  def staff_params

    params.require(:staff)
      .permit(:name, :email, :address, :phone_number, :designation, service_ids: [])
  end

  def get_all_staffs
    @staffs = Staff.where(true)
  end

  def new_staff(params = nil)
    @staff = Staff.new(params)
  end

  def get_all_services
    @services = Service.where(true)
  end

end
