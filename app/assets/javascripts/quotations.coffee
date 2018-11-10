window.quotationDataTablesLoad = () ->
  url = $(".quotation-table").data('url')
  $(".quotation-table").DataTable
    'destroy': true
    'searching': true
    'ajax':
      'url': url
      'data': filterFormSerializeJson($("#form_filter_quotation_data"))
    'processing': true
    'serverSide': true
    'fnDrawCallback': ->
      $(".quotation-modal").modal('hide')
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

window.quotationDataTablesReset = () ->
  table = quotationDataTablesLoad()
  table.ajax.reload()

ready = ->
  $("body").on "click", ".quotation-export-btn", (e) ->
    e.preventDefault()
    wrapper = $(this).closest('#quotation_export_modal')
    export_type = wrapper.find("input[name='export_type']:checked").val()
    if export_type == "pdf"
      url = wrapper.find("input[name='pdf_url']").val()
    else if export_type == "email"
      url = wrapper.find("input[name='email_url']").val()

    if url.length == 0
      alert("Sorry, URL you search is not exist.")
      $("#quotation_export_modal").modal("hide")
    else
      if export_type == "pdf"
        $.ajax
          url: url
          dataType: 'html'
          success: (data) ->
            window.open(url,'newStuff');
            $("#quotation_export_modal").modal("hide")
            return
      else if export_type == "email"
        $.ajax
          url: url
          dataType: 'js'
          data:
            email_sent_to: $("#email_sent_to_").val()
          success: (data) ->
            # window.open(url,'newStuff');
            # $("#invoice_export_modal").modal("hide")
            $("#invoice_export_modal").modal("hide");
            $(".modal-backdrop").remove();
            return
      $("#invoice_export_modal").modal("hide");
      $(".modal-backdrop").remove();

  $("body").on "click", ".quotation-export-link", (e) ->
    e.preventDefault()
    template = $("#quotation_export_modal_template").html()
    data = JSON.parse($(this).attr("data-quotation"))
    pdf_url = $(this).attr("data-pdf-url")
    email_url = $(this).attr("data-email-url")
    data["pdf_url"] = pdf_url
    data["email_url"] = email_url
    wrapper = $("#quotation_export_modal_wrapper")
    wrapper.html(Mustache.render(template, data))
    $("#quotation_export_modal").modal("show")
    export_email_chosen_jquery()


$(document).ready(ready);
$(document).on('page:change', ready);