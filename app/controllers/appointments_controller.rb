class AppointmentsController < ApplicationController

  def index
    @appointments = Appointment.all
  end

  def new
    @appointment = Appointment.new
    # @found_customer = Customer.find(params[:found_customer_id])
  end

  def destroy
  end

  def create
    @appointment = Appointment.new(appointment_params)

    if @appointment.save
      redirect_to @appointment
    else
      @found_patient = Customer.find(params[:appointment][:customer_id])
      render 'new'
    end
  end

  def show
  end

  private
  def appointment_params
    params.require(:appointment)
      .permit(:disease, :status, :staff_id, :customer_id, :slots, :appointment_datetime )
  end
end
