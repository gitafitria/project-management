# EVERYTHING IS NOT WORKING ON TURBOLINKS
window.renderInvoiceItem = ($this, index) ->
  form_wrapper = $("#invoice_form")
  invoice_item_list_wrapper = $this.closest(".invoice-item-form")
  add_invoice_item_template = form_wrapper.find("#add_invoice_item_template").html()

  data =
    idx: index

  options_wrapper = invoice_item_list_wrapper.find(".add-invoice-item-btn").closest(".row")
  unless $(".invoice-item-form").length == 1
    options_wrapper.find(".hidden").removeClass("hidden")
    # invoice_item_list_wrapper.find(".add-invoice-item-btn").closest(".col-md-6").remove()

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

# Select client using autocomplete
# This autocomplete return id of client (user)
#
window.recipientAutocomplete = () ->
  recipient = $(".recipient-autocomplete").autocomplete
    minLength: 1
    source: (request, response) ->
      $.ajax
        url: $(".recipient-autocomplete").data("source")
        dataType: 'json'
        data:
          by_name: request.term
          by_project: $("#invoice_project_id").val()
        success: (data) ->
          response data
          console.log data
          return
      return
    select: (event, ui) ->
      id = ui.item.id
      recipient_name = "#{ui.item.first_name} #{ui.item.last_name}"
      email = ui.item.email
      unless $("#selected_recipient_#{id}").length > 0
        renderRecipientOnInvoiceForm(id, recipient_name, email)
      $(".recipient-autocomplete").val("")
      false
    response: (event, ui) ->
      new_user_path = $('.recipient-autocomplete').attr('data-new-recipient-source')
      console.log new_user_path
      $("#recipient_not_found").remove()
      if ui.content.length is 0
        $(".recipient-autocomplete").after "<div id='recipient_not_found' class='help-block'>recipient you were looking for doesn't exist</div>"
      else
        $("#recipient_not_found").remove()
      return

  # district autocomplete menu formater
  unless recipient.data("ui-autocomplete") is undefined
    recipient.data("ui-autocomplete")._renderItem = (ul, item) ->
      content = "<label>#{item.first_name} #{item.last_name}</label>"
      content = content + " <small class='secondary-label'>#{item.email}</small>"
      $("<li>").append("<div>" + content + "</div>").appendTo ul

window.renderRecipientOnInvoiceForm = (id, client_name, email) ->
  new_client_template = "<label>#{client_name}</label> <small class='secondary-label'>#{email}</small>"
  new_client_template = new_client_template + "<input type='hidden' name='invoice[recipient_ids][]' value='#{id}'>"
  new_client_template = new_client_template + " <a class='btn btn-link remove-recipient-btn'>Remove</a>"
  template = "<div class='selected-recipient' id='selected_recipient_#{id}'>" + new_client_template + "</div>"
  $("#invoice_client_ids").append(template)

window.updateInvoiceTotalPayment = () ->
  total_payment = 0

  # Count total payment
  $(".invoice-unit-price").each () ->
    wrapper = $(this).closest(".invoice-item-form")
    quantity = wrapper.find(".invoice-quantity").val()

    unit_price = $(this).val()

    if unit_price == ""
      unit_price = 0

    if quantity == ""
      quantity = 0

    total_payment = total_payment + (parseInt(unit_price) * parseInt(quantity))

  # Calculate tax
  if ($("#invoice_is_tax_included").prop("checked") == false)
    tax = parseInt($("#invoice_tax").val())
    total_tax = total_payment * tax / 100

    total_payment = total_payment + total_tax
    $("#invoice_tax_payment").html(total_tax)

    $("#invoice_tax_payment_wrapper").removeClass("hide")
  else
    $("#invoice_tax_payment_wrapper").addClass("hide")

  # Submit Grand total payment
  $("#invoice_total_payment").html(total_payment)

ready = ->

  recipientAutocomplete()

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

    updateInvoiceTotalPayment()

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
    export_email_chosen_jquery()

  $("body").on "click", ".invoice-export-btn", (e) ->
    e.preventDefault()
    wrapper = $(this).closest('#invoice_export_modal')
    export_type = wrapper.find("input[name='export_type']:checked").val()
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

  $("body").on "keyup", ".chosen-container", (event) ->
    chosen_wrapper = $(this).parent().find(".email-chosen-select")
    if chosen_wrapper.length > 0
      if (event.which == 13)
        console.log "masuk pak eko!"
        chosen_wrapper.first().append('<option value="' + $(event.target).val() + '" selected="selected">' + $(event.target).val() + '</option>');
        chosen_wrapper.first().trigger('chosen:updated');

  $("body").on "change", "#invoice_project_id", (e) ->
    e.preventDefault()
    project_id = $(this).val()
    $("#invoice_recipients").find("#invoice_client_ids").html("")
    $("#recipient_autocomplete").val("")
    $("#recipient_not_found").remove()

    if project_id == ''
      $("#invoice_recipients").addClass "hide"
    else
      $("#invoice_recipients").removeClass "hide"

  $("body").on "click", ".remove-recipient-btn", (e) ->
    e.preventDefault()
    $(this).closest(".selected-recipient").remove()

  $("body").on "keyup change", ".invoice-unit-price", (e) ->
    e.preventDefault()
    updateInvoiceTotalPayment()

  $("body").on "keyup change", ".invoice-quantity", (e) ->
    e.preventDefault()
    updateInvoiceTotalPayment()

  $("body").on "keyup change", "#invoice_tax", (e) ->
    e.preventDefault()
    updateInvoiceTotalPayment()

  $("body").on "change", "#invoice_is_tax_included", (e) ->
    e.preventDefault()
    updateInvoiceTotalPayment()

$(document).ready(ready);
$(document).on('page:change', ready);