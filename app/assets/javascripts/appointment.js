$(document).ready(function() {
  $('.calendar').fullCalendar({
    header:
      {
        left:   'today prev next',
        center: 'title',
        right:  'month, agendaWeek, agendaDay'
      }
  })

  $('#new_event').click(function(event) {

    event.preventDefault();
    FullcalendarEngine.Form.display();
  })

});