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
//= require jquery_ujs
//= require bootstrap-sprockets
//= require bootstrap-datepicker
//= require mustache.min
//= require turbolinks
//= require jquery.dataTables.min
//= require dataTables.bootstrap.min
//= require chosen-jquery

//= require_tree .

function animateNotification(){
  $("#notifications .notice").hide().fadeIn(200);
  $("#notifications .notice").delay(5000).fadeOut(500);
  $("#notifications .alert").delay(5500).fadeOut(500);
}

function dataTablesLoad() {
  $("table[role='datatable']").each(function(){
    var url = $(this).data('url');

    if($(this).hasClass("project-table")){
      projectDataTablesLoad();
      // $(".dataTables_filter").remove();
    }else if($(this).hasClass("invoice-table")){
      invoiceDataTablesLoad();
    }else if($(this).hasClass("document-table")){
      documentDataTablesLoad();
    }
    // $(".dataTables_filter").remove();
  });
}

function chosen_jquery() {
  $(".chosen-select").chosen({
    allow_single_deselect: true,
    no_results_text: 'No results matched',
    width: '100%'
  });
  $(".default").css("width", "100%");
}

var ready;
ready = function() {
  animateNotification();
  dataTablesLoad();
  chosen_jquery();

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
// $(document).on('page:load', ready);
$(document).on('turbolinks:load', ready);
