class Staff::AppointmentsController < Staff::BaseController

  before_action :get_event, only: [:edit, :update, :destroy, :move, :resize, :cancel]
  before_action :get_controller
  before_action :get_staff_service_customer, only: [:index, :new, :update]


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

    appointments = Appointment.for_staff(current_user.id).by_timerange(start_time, end_time)
    events = []
    appointments.each do |event|
      events << { id: event.id,
                  description: event.description || '',
                  customer: event.customer.name, 
                  start: event.starttime.iso8601,
                  end: event.endtime.iso8601,
                  allDay: false,
                  title: event.title
                }
    end
    render json: events.to_json
  end

  def edit
    render json: { form: render_to_string(partial: 'edit_form') } 
  end

  def update
    @event = Appointment.new
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
    case params[:delete_all]
    when 'true'
      @event.event_series.destroy
    when 'future'
      @events = @event.event_series.events.where('starttime > :start_time',
                                                 start_time: @event.starttime.to_formatted_s(:db)).to_a
      @event.event_series.events.delete(@events)
    else
      @event.destroy
    end
    render nothing: true
  end

  def cancel
    render json: { form: render_to_string(partial: 'cancel_form') } 
  end

  private

  def get_event
    @event = Appointment.where(:id => params[:id]).first
    unless @event
      render json: { message: "Appointment Not Found.."}, status: 404 and return
    end
  end

  def event_params
    params.require(:appointment).permit(:staff_id, :customer_id, :starttime, :endtime, :status_id, :description, :remark )
  end

  def get_controller
    @controller_name = params[:controller]
  end

  def get_staff_service_customer
    @staffs = Staff.all
    @services = Service.all
    @customers = Customer.all
  end
end
