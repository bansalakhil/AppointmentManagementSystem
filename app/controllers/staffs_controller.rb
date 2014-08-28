class StaffsController < ApplicationController
  before_action :find_staff_member, only: [ :edit, :update, :destroy ]
  before_action :get_all_staffs, only: [ :index ]

  def index
  end

  def new
    new_staff
  end

  def edit
  end

  def create

    new_staff(staff_params)

    if @staff.save
      flash[:notice] = 'Staff successfully saved'
    else
      flash[:notice] = 'Staff could not be saved'
    end
    redirect_to_path(staffs_path)
  end

  def update

    if @staff.update(staff_params)
      flash[:notice] = 'Staff sucessfully updated'
    else
      flash[:notice] = 'Staff could not be updated'
    end
    redirect_to_path(staffs_path)
  end

  def destroy

    if @staff.destroy
      flash[:notice] = 'Staff sucessfully deleted'
    else
      flash[:notice] = 'Staff could not be deleted'
    end
    redirect_to_path(staffs_path)
  end

  private

  def find_staff_member
    @staff = Staff.where(params[:id]).first
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

end
