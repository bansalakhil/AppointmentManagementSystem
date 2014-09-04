class StaffsController < ApplicationController

  PERMITTED_ATTRS = [:name, :email, :phone_number, {service_ids: []}] 
  before_action :find_staff_member, only: [ :edit, :update, :destroy, :deactivate ]
  before_action :get_all_staffs, only: [ :index ]
  before_action :get_all_services, only: [:create, :new, :update, :edit]

  def index
  end

  def new
    new_staff
  end

  def edit
  end

  def create

    new_staff(staff_params)

    respond_to do |format|
      if @staff.save
        @staff.invite!
        flash[:notice] = 'Staff sucessfully created'
        format.js { render action: 'refresh' }
      else
        debugger
        flash[:notice] = 'Staff could not be created'
        format.js do
          get_all_services
          render action: 'edit'
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
        flash[:notice] = 'Staff could not be updated'
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
      flash[:notice] = 'Staff could not be deleted'
    end
    redirect_to_path(staffs_path)
  end

  def deactivate
    @staff.update_attribute('active', false)
    flash[:notice] = 'Staff sucessfully deleted'
    redirect_to_path(staffs_path)
  end

  private

  def find_staff_member
    @staff = Staff.where(id: params[:id]).first
  end

  def staff_params

    params.require(:staff)
      .permit(*PERMITTED_ATTRS)
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
