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
    
  #   new_record = $(this).data("new-record")

  #   console.log new_record


  # $("body").on "click", ".edit-project-milestone-btn", (e) ->
  #   e.preventDefault()
  #   index = $(this).data("index")
  #   milestone = $(this).data("milestone")
  #   form_wrapper = $("#project_form")
  #   edit_modal_wrapper = form_wrapper.find("#edit_project_milestone")
  #   milestone_item_wrapper = edit_modal_wrapper.find(".milestone-item")

  #   $.each milestone, (key, value) ->
  #     milestone_item_wrapper.find("#milestone_#{key}").val(value)

  #   milestone_id = milestone['id']
  #   new_record = milestone['new_record']

  #   if milestone_id == undefined
  #     milestone_id = milestone['index']
  #   edit_modal_wrapper.attr("data-milestone-id", milestone_id)
  #   edit_modal_wrapper.attr("data-new-record", new_record)
  #   edit_modal_wrapper.modal('show')

  # $("body").on "click", "#update_project_milestone_btn", (e) ->
  #   e.preventDefault()
  #   form_wrapper = $("#project_form")
  #   edit_modal_wrapper = $("#project_form").find("#edit_project_milestone")
  #   index = edit_modal_wrapper.attr("data-milestone-id")
  #   new_record = edit_modal_wrapper.attr("data-new-record")

  #   renderMilestoneItem("#edit_project_milestone", index, new_record)

$(document).ready(ready);
$(document).on('page:change', ready);