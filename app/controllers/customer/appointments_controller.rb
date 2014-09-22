class Customer::AppointmentsController < Customer::BaseController
  before_action :get_event, only: [:edit, :update, :destroy, :move, :resize, :cancel_list]
  before_action :get_controller
  before_action :get_services, only: [:index, :new, :update]

  def index
  end

  def new
    @event = Appointment.new
    respond_to do |format|
      format.js
    end
  end

  def create
    @event = Appointment.new(event_params)
    @event.customer_id = current_user.id
    if @event.save
      render nothing: true, status: :created
    else
      render text: @event.errors.full_messages.to_sentence, status: 422
    end
  end

  def get_events

    start_time = Time.at(params[:start].to_i).to_formatted_s(:db)
    end_time   = Time.at(params[:end].to_i).to_formatted_s(:db)

    if params[:staff_id] && params[:service_id]
      appointments = Appointment.for_customer(current_user.id)
                      .where('staff_id = ? and service_id = ?', params[:staff_id], params[:service_id])
                      .by_timerange(start_time, end_time)
    else
      appointments = Appointment.for_customer(current_user.id).by_timerange(start_time, end_time)
    end

    events = []
    appointments.each do |event|
      events << {
                  id: event.id,
                  description: event.description || '',
                  customer: event.customer.name, 
                  start: event.starttime.iso8601,
                  end: event.endtime.iso8601,
                  allDay: false,
                  title: event.title,
                  backgroundColor: event.staff.try(:color),
                  textColor: '#000'
                }
    end
    render json: events.to_json
  end

  def get_staff
    respond_to do |format|
      format.js do
        @staffs = Service.where(id: params[:service_id]).first.try(:staffs)
        render json: @staffs
      end
    end
  end

  def edit
    render json: { form: render_to_string(partial: 'edit_form') }
  end

  def update
    @event.update(event_params)
    render nothing: true
  end

  def destroy
    respond_to do |format|
      format.js do
        @event.update_columns(remark: params[:remark], status: 3)
        flash[:error] = 'Appointment cannot be cancelled' unless @event.destroy
        render nothing: true
      end
      format.html do
        @event.update_columns(remark: params[:appointment][:remark], status: 3)
        flash[:error] = 'Appointment cannot be cancelled' unless @event.destroy
        redirect_to appointment_history_customer_appointments_path
      end
    end

  end

  def appointment_history
    @future_appointments = Appointment.future.where(customer_id: current_user.id).paginate page: params[:page], per_page: 10
    @past_appointments = Appointment.past.where(customer_id: current_user.id).paginate page: params[:page], per_page: 10
  end

  #Customer can move events
  def move
    @event.starttime = make_time_from_minute_and_day_delta(@event.starttime)
    @event.endtime   = make_time_from_minute_and_day_delta(@event.endtime)
    if @event.save
      render nothing: true
    else
      render json: { message: 'This service could not be moved' }
    end
  end

  #Customer can move events
  def resize
    @event.endtime = make_time_from_minute_and_day_delta(@event.endtime)
    if @event.save
      render nothing: true
    else
      render json: { message: 'This service could not be resized' }
    end
  end

  def cancel_list
  end

  private

  def get_event
    @event = Appointment.where(:id => params[:id]).first
    unless @event
      render json: { message: "Appointment Not Found.."}, status: 404 and return
    end
  end

  def event_params
    params.require(:appointment)
      .permit(:staff_id, :service_id, :title, :starttime, :endtime, :status_id, :description, :remark)
  end

  # FIX- Move to helpers
  def get_controller
    @controller_name = params[:controller]
  end

  def get_services
    @services = [['Select', '']]
    Availability.all.uniq(:service_id).each {|av| @services << [av.service.name, av.service_id]}
    @services
  end

  def make_time_from_minute_and_day_delta(event_time)
    params[:minute_delta].to_i.minutes.from_now((params[:day_delta].to_i).days.from_now(event_time))
  end

end