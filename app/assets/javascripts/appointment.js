$(document).ready(function(){
  FULLCALENDAR_OPTIONS = {
    editable    : true,
    header      : {
      left: 'prev,next today',
      center: 'title',
      right: 'month,agendaWeek,agendaDay'
    },
    defaultView : 'agendaWeek',
    height      : 500,
    slotMinutes : 15,
    dragOpacity : 0.5,
    selectable  : true,
    timeFormat  : "h:mm t{ - h:mm t}",
    handleWindowResize: true,
    events      : '/' + window.app_path + '/get_events',
    editable    : true,
    disableDragging: false,
    disableResizing: false,
    allDay      : false,
    eventBackgroundColor : '#ff0000',
    dayRender   : function(date, cell){
                    if (date > $.now()){
                      $(cell).addClass('disabled');
                    }
                  },
    select      : function(startDate, endDate, jsEvent, view){
                    if (controller == 'customer') {
                      FullcalendarEngine.Form.display({ 
                        starttime: startDate,
                        endtime:   endDate,
                      });
                    }
                  },
    eventResize : function(event, dayDelta, minuteDelta, revertFunc){
                    if (controller == 'customer'){
                      FullcalendarEngine.Events.resize(event, dayDelta, minuteDelta);
                    }
                  },
    eventDrop   : function(event, dayDelta, minuteDelta, allDay, revertFunc){
                    if (controller == 'customer'){
                      FullcalendarEngine.Events.move(event, dayDelta, minuteDelta, allDay);
                    }
                  },
    eventClick  : function(event, jsEvent, view){
                    FullcalendarEngine.Events.showEventDetails(event);
                  },
    loading     : function(bool){
                    if (bool) 
                      $('#loading').show();
                    else
                      $('#loading').hide();
                  }

  };

  custom_calendar(FULLCALENDAR_OPTIONS);

  $('#appointment_select_staff_id, #appointment_select_service_id').on('change', function(){
    var staff_id = $('#appointment_select_staff_id').val();
    var service_id = $('#appointment_select_service_id').val();
    if(staff_id == ''){
      alert('Select a staff for this service [MANDATORY]');
      $.ajax({
        type: 'get',
        data: "&service_id=" + service_id,
        async: true,
        dataType: 'json',
        url: '/' + app_path + '/get_staff',
        success: function(staffs, status, xhr) {

          var selectbox = $('#appointment_select_staff_id');
          selectbox.empty();
          if(staffs) {
            option = $("<option />").attr({value: ''}).text('Staff');
            selectbox.append(option);
            $.each (staffs, function(index, staff) {
              option = $("<option />").attr({value: staff.id}).text(staff.name);
              selectbox.append(option);
            })
          }
        },
        error: function() {}
      });
    }else if(staff_id != '' && service_id != ''){
      $('#calendar').html('');
      FULLCALENDAR_OPTIONS.events = '/' + app_path + '/get_events?&staff_id=' + staff_id + "&service_id=" + service_id ;
      custom_calendar(FULLCALENDAR_OPTIONS);
    }
  });
});

custom_calendar = function(FULLCALENDAR_OPTIONS) {
  controller = app_path.slice(0, app_path.search('/'))
  $('#calendar').fullCalendar(FULLCALENDAR_OPTIONS);

  $('#new_event').click(function(event) {
    event.preventDefault();
    controller = app_path.slice(0, app_path.search('/'))
    if (controller != 'admin') {
      FullcalendarEngine.Form.display();
    }
  });
}