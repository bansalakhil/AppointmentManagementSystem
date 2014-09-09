class Admin::AppointmentsController < Admin::BaseController
    before_filter :load_event, only: [:edit, :update, :destroy, :move, :resize, :cancel]
    before_action :get_controller

    def index
      @staffs = Staff.all
      @customers = Customer.all
      @services = Service.all
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
      @staffs = Staff.all
      @services = Service.all
      @customers = Customer.all
      @event = Appointment.new
      respond_to do |format|
        format.js
      end
    end

    def get_events
      start_time = Time.at(params[:start].to_i).to_formatted_s(:db)
      end_time   = Time.at(params[:end].to_i).to_formatted_s(:db)

      @events = Appointment.where('
                  (starttime >= :start_time and endtime <= :end_time) or
                  (starttime >= :start_time and endtime > :end_time and starttime <= :end_time) or
                  (starttime <= :start_time and endtime >= :start_time and endtime <= :end_time) or
                  (starttime <= :start_time and endtime > :end_time)',
                  start_time: start_time, end_time: end_time)
      events = []
      @events.each do |event|
        events << { id: event.id,
                    description: event.description || '', 
                    start: event.starttime.iso8601,
                    end: event.endtime.iso8601,
                    allDay: false}
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
      @staffs = Staff.all
      @customers = Customer.all
      @event = Appointment.new
      @services = Service.all
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
      @future_appointments = Appointment.where('starttime > :current_time and status_id = 1', current_time: Time.now)
      @past_appointments = Appointment.where('endtime < :current_time and status_id = 4', current_time: Time.now)
    end

    def cancel
      @event.destroy
      redirect_to appointment_history_admin_appointments_path
    end

    private

    def load_event
      @event = Appointment.where(:id => params[:id]).first
      unless @event
        render json: { message: "Appointment Not Found.."}, status: 404 and return
      end
    end

    def event_params
      params.require(:appointment).permit(:staff_id, :service_id, :customer_id, :starttime, :endtime, :status_id, :description )
    end

    def get_controller
      @controller_name = params[:controller]
    end
end
