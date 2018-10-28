# EVERYTHING IS NOT WORKING ON TURBOLINKS
window.renderInvoiceItem = ($this, index) ->
  form_wrapper = $("#invoice_form")
  invoice_item_list_wrapper = $this.closest(".invoice-item-form")
  add_invoice_item_template = form_wrapper.find("#add_invoice_item_template").html()

  data = 
    idx: index

  options_wrapper = invoice_item_list_wrapper.find(".add-invoice-item-btn").closest(".row")
  options_wrapper.find(".hidden").removeClass("hidden")
  invoice_item_list_wrapper.find(".add-invoice-item-btn").closest(".col-md-6").remove()

  invoice_item_list_wrapper.after(Mustache.render(add_invoice_item_template, data))

window.invoiceDataTablesLoad = () ->
  url = $(".invoice-table").data('url')
  $(".invoice-table").DataTable
    'destroy': true
    'searching': true
    'ajax':
      'url': url
      'data': filterFormSerializeJson($("#form_filter_invoice_data"))
    'processing': true
    'serverSide': true
    'fnDrawCallback': ->
      $(".invoice-modal").modal('hide')
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

window.invoiceDataTablesReset = () ->
  table = invoiceDataTablesLoad()
  table.ajax.reload()

ready = ->

  $("body").on "click", ".add-invoice-item-btn", (e) ->
    e.preventDefault();
    index = (new Date).getTime()
    renderInvoiceItem($(this), index)

  $("body").on "click", ".remove-invoice-item-btn", (e) ->
    e.preventDefault()
    current_invoice_item = $(this).closest(".invoice-item-form")
    index = current_invoice_item.data("id")
    form_wrapper = $("#invoice_form")

    delete_template = form_wrapper.find("#delete_invoice_item_template").html()

    console.log index == undefined

    # IF index == undefined, THEN record is new
    if index == undefined
      current_invoice_item.remove()
    else
      data = 
        index: index
      current_invoice_item.replaceWith(Mustache.render(delete_template, data))
    
  $("body").on "click", ".invoice-export-link", (e) ->
    e.preventDefault()
    template = $("#invoice_export_modal_template").html()
    data = JSON.parse($(this).attr("data-invoice"))
    pdf_url = $(this).attr("data-pdf-url")
    email_url = $(this).attr("data-email-url")
    data["pdf_url"] = pdf_url
    data["email_url"] = email_url
    wrapper = $("#invoice_export_modal_wrapper")
    wrapper.html(Mustache.render(template, data))
    $("#invoice_export_modal").modal("show")

  $("body").on "click", ".invoice-export-btn", (e) ->
    e.preventDefault()
    wrapper = $(this).closest('#invoice_export_modal')
    export_type = wrapper.find("input[name='export_type']:checked").val()
    console.log export_type
    if export_type == "pdf"
      url = wrapper.find("input[name='pdf_url']").val()
    else if export_type == "email"
      url = wrapper.find("input[name='email_url']").val()
    
    if url.length == 0
      alert("Sorry, URL you search is not exist.")
      $("#invoice_export_modal").modal("hide")
    else
      if export_type == "pdf"
        $.ajax
          url: url
          dataType: 'html'
          success: (data) ->
            window.open(url,'newStuff');
            $("#invoice_export_modal").modal("hide")
            return
      else if export_type == "email"
        $.ajax
          url: url
          dataType: 'js'
          success: (data) ->
            # window.open(url,'newStuff');
            $("#invoice_export_modal").modal("hide")
            return

$(document).ready(ready);
$(document).on('page:change', ready);