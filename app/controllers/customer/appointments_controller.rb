
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

    if @event.save
      render nothing: true, status: :created
    else
      render text: @event.errors.full_messages.to_sentence, status: 422
    end
  end

  def get_events

    start_time = Time.at(params[:start].to_i).to_formatted_s(:db)
    end_time   = Time.at(params[:end].to_i).to_formatted_s(:db)

    appointments = Appointment.by_timerange(start_time, end_time)
    events = []
    appointments.each do |event|
      events << { id: event.id,
                  description: event.description || '', 
                  start: event.starttime.iso8601,
                  end: event.endtime.iso8601,
                  allDay: false
                }
    end
    render json: events.to_json
  end

  def serving_staff
    respond_to do |format|
      format.js do
        @staffs = Service.where(id: params[:service_id]).first.try(:staffs)
        render json: @staffs
      end
    end
  end

  def move
    # FIX- @event will always be present here.
    if @event
      # @event.starttime = make_time_from_minute_and_day_delta(@event.starttime)
      @event.starttime = params[:start_time]
      # @event.endtime = params[:end_time]
      # @event.endtime   = make_time_from_minute_and_day_delta(@event.endtime)
      # @event.all_day   = params[:all_day]
      # FIX- What if @event is not saved successfully?
      @event.save
    end
    render nothing: true
  end

  def resize
    if @event
      @event.endtime = params[:end_time]
      # @event.endtime = make_time_from_minute_and_day_delta(@event.endtime)
      @event.save
    end    
    render nothing: true
  end

  def edit
    render json: { form: render_to_string(partial: 'edit_form') } 
  end

  # FIX- Refactor this. Unable to review.
  def update

    case params[:event][:commit_button]
    when 'Update All Occurrence'
      @events = @event.event_series.events
      @event.update_events(@events, event_params)
    when 'Update All Following Occurrence'
      @events = @event.event_series.events.where('starttime > :start_time', 
                                                 start_time: @event.starttime.to_formatted_s(:db)).to_a
      @event.update_events(@events, event_params)
    else
      @event.attributes = event_params
      @event.save
    end
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
      # FIX- We dont need to call return here
      render json: { message: "Appointment Not Found.."}, status: 404 and return
    end
  end

  def event_params
    params.require(:appointment)
      .permit(:staff_id, :service_id, :starttime, :endtime, :status_id, :description )
  end

  # FIX- Move to helpers
  def get_controller
    @controller_name = params[:controller]
  end

  def get_services
    @services = Service.all
  end
end
