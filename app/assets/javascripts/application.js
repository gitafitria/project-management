// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require jquery
//= require bootstrap-sprockets
//= require bootstrap-datepicker
//= require mustache.min
//= require turbolinks
//= require_tree .

function animateNotification(){
  $("#notifications .notice").hide().fadeIn(200);
  $("#notifications .notice").delay(5000).fadeOut(500);
  $("#notifications .alert").delay(5500).fadeOut(500);
}

var ready;
ready = function() {
  animateNotification();

  // Default date picker to all input with .datepicker class
  $('body').on("click focus", ".datepicker", function(){
    $(this).datepicker({
      format: 'yyyy-mm-dd',
      todayHighlight: true,
      todayBtn: 'linked',
      weekStart: 1,
      autoclose: true
    });
  });
}

$(document).ready(ready);
$(document).on('page:load', ready);
