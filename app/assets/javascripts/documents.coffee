# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
window.documentDataTablesLoad = () ->
  url = $(".document-table").data('url')
  $(".document-table").DataTable
    'destroy': true
    'searching': true
    'ajax':
      'url': url
      'data': filterFormSerializeJson($("#form_filter_document_data"))
    'processing': true
    'serverSide': true
    'fnDrawCallback': ->
      $(".document-modal").modal('hide')
      return
      #   # show data table to the top of page when switch pagination
      #   $('html, body').animate { scrollTop: $('body').offset().top }, 'slow'
      #   filterDataOption()
      #   updateExportFilter()
      #   showHideTableColumn()
      #   isolateFilterLabel()
      #   $('.new-slide-panel').css 'display', 'none'
      #   checkIt()
      #   tooltipAndPopoverShow()
      #   # counterCheck()
    'aoColumnDefs': [ {
      'bSortable': false
      'aTargets': [
        'col-options-column'
      ]
    } ]
    start: 0

window.documentDataTablesReset = () ->
  table = documentDataTablesLoad()
  table.ajax.reload()

ready = ->
  $("body").on "click", ".document-export-link", (e) ->
    e.preventDefault()
    template = $("#document_export_modal_template").html()
    data = JSON.parse($(this).attr("data-document"))
    pdf_url = $(this).attr("data-pdf-url")
    email_url = $(this).attr("data-email-url")
    data["pdf_url"] = pdf_url
    data["email_url"] = email_url
    wrapper = $("#document_export_modal_wrapper")
    wrapper.html(Mustache.render(template, data))
    $("#document_export_modal").modal("show")

  $("body").on "click", ".document-export-btn", (e) ->
    e.preventDefault()
    wrapper = $(this).closest('#document_export_modal')
    export_type = wrapper.find("input[name='export_type']:checked").val()
    console.log export_type
    if export_type == "pdf"
      url = wrapper.find("input[name='pdf_url']").val()
    else if export_type == "email"
      url = wrapper.find("input[name='email_url']").val()

    if url.length == 0
      alert("Sorry, URL you search is not exist.")
      $("#document_export_modal").modal("hide")
    else
      if export_type == "pdf"
        $.ajax
          url: url
          dataType: 'html'
          success: (data) ->
            window.open(url,'newStuff');
            $("#document_export_modal").modal("hide")
            return
      else if export_type == "email"
        $.ajax
          url: url
          dataType: 'js'
          success: (data) ->
            # window.open(url,'newStuff');
            $("#document_export_modal").modal("hide")
            return

$(document).ready(ready);
$(document).on('page:change', ready);