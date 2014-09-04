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
    select      : function(start, end, jsEvent, view){
                    FullcalendarEngine.Form.display({ 
                      // starttime: new Date(startDate.getTime()), 
                      // endtime:   new Date(endDate.getTime()), 
                      // allDay:    allDay 
                    })
                  },
  });

  $('#new_event').click(function(event) {
    event.preventDefault();
    // FullcalendarEngine.Form.display()
  });
}