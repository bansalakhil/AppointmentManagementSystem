class Customer::AppointmentsController < Customer::BaseController
  before_action :get_event, only: [:edit, :update, :destroy, :move, :resize]
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
    @event.title = @event.staff.name + '//' + @event.service.name

    if @event.save
      render nothing: true, status: :created
    else
      render text: @event.errors.full_messages.to_sentence, status: 422
    end
  end

  def get_events

    start_time = Time.at(params[:start].to_i).to_formatted_s(:db)
    end_time   = Time.at(params[:end].to_i).to_formatted_s(:db)

    appointments = Appointment.for_customer(current_user.id).by_timerange(start_time, end_time)
    events = []
    appointments.each do |event|
      events << { id: event.id,
                  description: event.description || '', 
                  start: event.starttime.iso8601,
                  end: event.endtime.iso8601,
                  allDay: false,
                  title: event.title
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

  def move
    @event.starttime = make_time_from_minute_and_day_delta(@event.starttime)
    @event.endtime   = make_time_from_minute_and_day_delta(@event.endtime)
    if @event.save
      flash[:notice] = 'Appointment saved succssfully'
    else
      flash[:error] = 'Appointment could not be saved'
    end
    render nothing: true
  end

  def resize
    @event.endtime = make_time_from_minute_and_day_delta(@event.endtime)
    @event.save
    render nothing: true
  end

  def edit
    render json: { form: render_to_string(partial: 'edit_form') } 
  end

  def update
    # @event.attributes = event_params
    @event.update(event_params)
    # @event.save
    render nothing: true
  end

  def destroy
    # FIX- No failure case handled
    @event.destroy
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
    params.require(:appointment)
      .permit(:staff_id, :service_id, :title, :starttime, :endtime, :status_id, :description )
  end

  # FIX- Move to helpers
  def get_controller
    @controller_name = params[:controller]
  end

  def get_services
    @services = Service.all
  end

  def make_time_from_minute_and_day_delta(event_time)
    params[:minute_delta].to_i.minutes.from_now((params[:day_delta].to_i).days.from_now(event_time))
  end
end
