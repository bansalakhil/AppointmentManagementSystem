// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .







function set_appointment_datetime(){
  var date = [],
      time = [];
  date.push ($('#appointment_day').val());
  date.push ($('#appointment_month').val());
  date.push ($('#appointment_year').val());
  date = date.join('/');

  time.push ($('#appointment_hour').val());
  time.push ($('#appointment_day').val());
  time = time.join(':');
  datetime = date + " " + time;
  $('#appointment_appointment_datetime').val(datetime);

}


//= require fullcalendar_engine/application
