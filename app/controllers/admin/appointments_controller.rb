class Admin::AppointmentsController < Admin::BaseController
  before_action :get_event, only: [:edit, :update, :destroy, :move, :resize, :cancel, :set_done]
  before_action :get_controller
  before_action :get_staff_service_customer, only: [:index, :new, :update, :edit]

  def index
  end

  def create
    @event = Appointment.new(event_params)
    if @event.save
      render nothing: true
    else
      render text: @event.errors.full_messages.to_sentence, status: 422
    end
  end

  def new
    @event = Appointment.new
    respond_to do |format|
      format.js
    end
  end

  def get_events
    start_time = Time.at(params[:start].to_i).to_formatted_s(:db)
    end_time   = Time.at(params[:end].to_i).to_formatted_s(:db)

    appointments = Appointment.by_timerange(start_time, end_time)
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

  def edit
    render json: { form: render_to_string(partial: 'edit_form') } 
  end

  def update
    @event = @event.update(event_params)
    render nothing: true #PROBLEM
  end

  def destroy
    @event.update_attributes(remark: params[:remark], status: 3)
    flash[:error] = 'Appointment cannot be cancelled' unless @event.destroy
    render nothing: true
  end

  def listing
    @appointments = Appointment.with_deleted.paginate :page => params[:page], :per_page => 10
  end

  def set_done
    @event.remark = params[:remark]
    @event.status = 4
    @event.save(validate: false)
    render nothing: true
  end

  def get_staff
    respond_to do |format|
      format.js do
        @staffs = Service.where(id: params[:service_id]).first.try(:staffs)
        render json: @staffs
      end
    end
  end

  def move
    @event.starttime = make_time_from_minute_and_day_delta(@event.starttime)
    @event.endtime   = make_time_from_minute_and_day_delta(@event.endtime)
    @event.all_day   = params[:all_day]
    @event.save
    render nothing: true
  end

  def resize
    @event.endtime = make_time_from_minute_and_day_delta(@event.endtime)
    @event.save
    render nothing: true
  end

  private

  def get_event
    
    @event = Appointment.where(:id => params[:id]).first
    unless @event
      render json: { message: "Appointment Not Found.."}, status: 404 and return
    end
  end

  def event_params
    params.require(:appointment).permit(:staff_id, :service_id, :customer_id, :starttime, :endtime, :status_id, :description, :remark )
  end

  # FIX- Move it to helper as it is related to view only.
  def get_controller
    @controller_name = params[:controller]
  end

  def get_staff_service_customer
    @staffs = Staff.all
    @services = Service.all
    @customers = Customer.all
  end

  def make_time_from_minute_and_day_delta(event_time)
    params[:minute_delta].to_i.minutes.from_now((params[:day_delta].to_i).days.from_now(event_time))
  end
end
