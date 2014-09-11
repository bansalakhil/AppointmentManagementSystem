class Admin::AppointmentsController < Admin::BaseController
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

      appointments = Appointment.by_timerange(start_time, end_time)
      events = []
      appointments.each do |event|
        events << {
                    id: event.id,
                    description: event.description || '', 
                    start: event.starttime.iso8601,
                    end: event.endtime.iso8601,
                    allDay: false
                  }
      end
      render json: events.to_json
    end

    def move
      if @event
        # @event.starttime = make_time_from_minute_and_day_delta(@event.starttime)
        @event.starttime = params[:start_time]
        # @event.endtime = params[:end_time]
        # @event.endtime   = make_time_from_minute_and_day_delta(@event.endtime)
        # @event.all_day   = params[:all_day]
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
      @event.destroy
      render nothing: true
    end

    def appointment_history
      @future_appointments = Appointment.future
      @past_appointments = Appointment.past
    end

    def cancel
      @event.destroy
      redirect_to appointment_history_admin_appointments_path
    end

    def listing
      @appointments = Appointment.future
    end

    private

    def get_event
      
      @event = Appointment.where(:id => params[:id]).first
      unless @event
        render json: { message: "Appointment Not Found.."}, status: 404 and return
      end
    end

    def event_params
      params.require(:appointment).permit(:staff_id, :service_id, :customer_id, :starttime, :endtime, :status_id, :description )
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
end
