$(document).ready(function(){
  custom_calendar();
});

custom_calendar = function() {
  controller = app_path.slice(0, app_path.search('/'))
  $('#calendar').fullCalendar({
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
    events      : '/' + app_path + '/get_events',
    editable    : true,
    disableDragging: false,
    disableResizing: false,
    allDay      : false,
    eventBackgroundColor : '#ff0000',
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

  });

  $('#new_event').click(function(event) {
    event.preventDefault();
    controller = app_path.slice(0, app_path.search('/'))
    if (controller != 'admin') {
      FullcalendarEngine.Form.display();
    }
  });
}