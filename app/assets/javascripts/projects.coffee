# EVERYTHING IS NOT WORKING ON TURBOLINKS
window.renderMilestoneItem = (modal_wrapper_name, index, new_record) ->
  form_wrapper = $("#project_form")
  milestone_list_wrapper = form_wrapper.find("#project_milestone_list").find("#accordion")
  add_milestone_template = form_wrapper.find("#add_milestone_template").html()
  modal_wrapper = $("#project_form").find("#{modal_wrapper_name}")

  data = {}
  milestone = {}

  milestone_input = modal_wrapper.find(".milestone-item").find(".project_milestone_form")
  milestone_input.each (index) ->
    data[$(this).attr("name")] = $(this).val()

  milestone = data
  milestone["index"] = index

  if new_record == true or new_record == "true"
    milestone["new_record"] = true
    milestone["milestone"] = JSON.stringify(data)
    milestone_list_wrapper.append(Mustache.render(add_milestone_template, milestone))
  else
    # update
    milestone["id"] = index
    milestone["new_record"] = false

    milestone_item = milestone_list_wrapper.find("#heading_milestone_#{index}").closest(".panel")
    milestone_item.replaceWith(Mustache.render(add_milestone_template, milestone))

    milestone_list_wrapper.find("#heading_milestone_#{index}").find(".edit-project-milestone-btn").attr("data-milestone", JSON.stringify(milestone))

  milestone_input.val("")
  modal_wrapper.modal('hide')

window.projectDataTablesLoad = () ->
  url = $(".project-table").data('url')
  $(".project-table").DataTable
    'destroy': true
    'searching': true
    'ajax':
      'url': url
      'data': filterFormSerializeJson($("#form_filter_project_data"))
    'processing': true
    'serverSide': true
    'fnDrawCallback': ->
      $(".project-modal").modal('hide')
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

window.filterFormSerializeJson = ($wrapper) ->
  arr = $wrapper.find("input, select").serializeArray()
  search = {}
  $.each arr, (idx, obj) ->
    name = obj["name"]
    value = obj["value"]
    search[name] = value
  return search

window.projectDataTablesReset = () ->
  table = projectDataTablesLoad()
  table.ajax.reload()

ready = ->

  $("body").on "click", "#add_project_milestone_btn", (e) ->
    e.preventDefault();
    index = (new Date).getTime()
    renderMilestoneItem("#add_project_milestone", index, true)

  $("body").on "click", ".delete-project-milestone-btn", (e) ->
    e.preventDefault()
    index = $(this).data("index")
    form_wrapper = $("#project_form")

    add_milestone_template = form_wrapper.find("#delete_milestone_template").html()
    current_milestone = form_wrapper.find("#heading_milestone_#{index}")

    new_record = $(this).data("new-record")
    data =
      index: index

    console.log new_record

    if new_record == false
      current_milestone.closest(".panel").replaceWith(Mustache.render(add_milestone_template, data))
    else
      current_milestone.closest(".panel").remove()

  $("body").on "click", ".edit-project-milestone-btn", (e) ->
    e.preventDefault()
    index = $(this).data("index")
    milestone = $(this).data("milestone")
    form_wrapper = $("#project_form")
    edit_modal_wrapper = form_wrapper.find("#edit_project_milestone")
    milestone_item_wrapper = edit_modal_wrapper.find(".milestone-item")

    $.each milestone, (key, value) ->
      milestone_item_wrapper.find("#milestone_#{key}").val(value)

    milestone_id = milestone['id']
    new_record = milestone['new_record']

    if milestone_id == undefined
      milestone_id = milestone['index']
    edit_modal_wrapper.attr("data-milestone-id", milestone_id)
    edit_modal_wrapper.attr("data-new-record", new_record)
    edit_modal_wrapper.modal('show')

  $("body").on "click", "#update_project_milestone_btn", (e) ->
    e.preventDefault()
    form_wrapper = $("#project_form")
    edit_modal_wrapper = $("#project_form").find("#edit_project_milestone")
    index = edit_modal_wrapper.attr("data-milestone-id")
    new_record = edit_modal_wrapper.attr("data-new-record")

    renderMilestoneItem("#edit_project_milestone", index, new_record)

  $("body").on "click", ".submit-filter-btn", (e)->
    e.preventDefault()
    form_wrapper = $(this).closest("form")
    form_id = form_wrapper.attr("id")
    if form_id == "form_filter_project_data"
      projectDataTablesReset()
    else if form_id == "form_filter_invoice_data"
      invoiceDataTablesReset()
    else if form_id == "form_filter_document_data"
      documentDataTablesReset()

$(document).ready(ready);
$(document).on('page:change', ready);