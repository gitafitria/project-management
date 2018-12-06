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
//= require jquery-ui/widgets/autocomplete
//= require bootstrap-sprockets
//= require bootstrap-datepicker
//= require mustache.min
//= require turbolinks
//= require jquery.dataTables.min
//= require dataTables.bootstrap.min
//= require chosen-jquery
//= require trix
//= require raphael
//= require morris

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
    }else if($(this).hasClass("quotation-table")){
      quotationDataTablesLoad();
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

function export_email_chosen_jquery() {
  $(".chosen-select").chosen({
    allow_single_deselect: true,
    no_results_text: 'Enter to add email',
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

  $("body").on("click", ".submit-filter-btn", function(e) {
    e.preventDefault();
    var form_wrapper = $(this).closest("form");
    var form_id = form_wrapper.attr("id");
    if (form_id == "form_filter_project_data") {
      projectDataTablesReset();
    } else if (form_id == "form_filter_invoice_data") {
      invoiceDataTablesReset();
    } else if (form_id == "form_filter_document_data") {
      documentDataTablesReset();
    } else if (form_id == "form_filter_quotation_data") {
      quotationDataTablesReset();
    }
  });

  $("body").on("click", ".btn-clear-filter", function(e) {
    e.preventDefault();
    var form_wrapper = $(this).closest("form");
    var form_id = form_wrapper.attr("id");
    clearFilterForm($("#"+ form_id));
    if (form_id == "form_filter_project_data") {
      projectDataTablesReset();
    } else if (form_id == "form_filter_invoice_data") {
      invoiceDataTablesReset();
    } else if (form_id == "form_filter_document_data") {
      documentDataTablesReset();
    } else if (form_id == "form_filter_quotation_data") {
      quotationDataTablesReset();
    }
  });


  $("body").on("click", "input[name='export_type']", function(e) {
    var export_type = $(this).val();
    if (export_type == "pdf"){
      $("#sent_email_to").addClass("hide");
    } else if (export_type == "email"){
      $("#sent_email_to").removeClass("hide");
    }
  });

} // end of ready

$(document).ready(ready);
// $(document).on('page:load', ready);
$(document).on('turbolinks:load', ready);
