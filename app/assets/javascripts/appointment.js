$(document).ready(function(){
  custom_calendar();
});

custom_calendar = function() {
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
    events      : '/appointments/get_events',
    editable    : true,
    disableDragging: false,
    disableResizing: false,
    allDay      : true,
    select      : function(start, end, jsEvent, view){
                    FullcalendarEngine.Form.display({ 
                      // starttime: new Date(startDate.getTime()), 
                      // endtime:   new Date(endDate.getTime()), 
                      // allDay:    allDay 
                    })
                  },
    eventResize : function(event, revertFunc, jsEvent) {
                    FullcalendarEngine.Events.resize(event);
                  },
    eventDrop   : function(event) {
                    FullcalendarEngine.Events.move(event);
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
    FullcalendarEngine.Form.display();
  });
}