class StaffsController < ApplicationController
  before_action :find_staff_member, only: [ :edit, :update, :destroy ]

  def index

    @staffs = Staff.all
  end

  def new

    @staff = Staff.new
    @services = Service.all
  end

  def edit
  end

  def create

    @staff = Staff.new(staff_params)
    @staff.save
    redirect_to staffs_path
    # flash[:notice] = "Staff cannot be created"
  end

  def update

    @staff.update(staff_params)
    redirect_to staffs_path
  end

  def destroy

    @staff.delete
    redirect_to staffs_path
  end

  private

  def find_staff_member
    @staff = Staff.find(params[:id])
  end

  def staff_params

    params.require(:staff)
      .permit(:name, :email, :address, :phone_number, :designation, service_ids: [])
  end

end
