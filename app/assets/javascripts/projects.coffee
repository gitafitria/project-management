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

window.clearFilterForm = ($wrapper) ->
  form_input = $wrapper
  form_input.find("input, select").val("")
  form_input.find("input[value='']").prop('checked',true)
  form_input.find(".chosen-select").val('').trigger("chosen:updated");

window.projectDataTablesReset = () ->
  table = projectDataTablesLoad()
  table.ajax.reload()

# Select client using autocomplete
# This autocomplete return id of client (user)
#
window.clientAutocomplete = () ->
  client = $(".client-autocomplete").autocomplete
    minLength: 1
    source: (request, response) ->
      $.ajax
        url: $(".client-autocomplete").data("source")
        dataType: 'json'
        data:
          by_name: request.term
        success: (data) ->
          response data
          console.log data
          return
      return
    select: (event, ui) ->
      id = ui.item.id
      client_name = "#{ui.item.first_name} #{ui.item.last_name}"
      email = ui.item.email
      renderClientOnProjectForm(id, client_name, email)
      # new_client_template = "<div class='selected-client'><label>#{ui.item.first_name} #{ui.item.last_name}</label> <small class='secondary-label'>#{ui.item.email}</small></div>"
      # new_client_template = new_client_template + "<input type='hidden' name='project[client_ids][]' value='#{ui.item.id}'>"
      # $("#project_client_ids").append(new_client_template)
      $(".client-autocomplete").val("")
      false
    response: (event, ui) ->
      new_user_path = $('.client-autocomplete').attr('data-new-client-source')
      console.log new_user_path
      $("#client_not_found").remove()
      if ui.content.length is 0
        $(".client-autocomplete").after "<div id='client_not_found' class='help-block'>Client you were looking for doesn't exist, <a href='#' class='add-new-client-project-btn'>Add new client.</a></span></div>"
      else
        $("#client_not_found").remove()
      return

  # district autocomplete menu formater
  unless client.data("ui-autocomplete") is undefined
    client.data("ui-autocomplete")._renderItem = (ul, item) ->
      content = "<label>#{item.first_name} #{item.last_name}</label>"
      content = content + " <small class='secondary-label'>#{item.email}</small>"
      $("<li>").append("<div>" + content + "</div>").appendTo ul

window.renderClientOnProjectForm = (id, client_name, email) ->
  new_client_template = "<div class='selected-client'><label>#{client_name}</label> <small class='secondary-label'>#{email}</small></div>"
  new_client_template = new_client_template + "<input type='hidden' name='project[client_ids][]' value='#{id}'>"
  $("#project_client_ids").append(new_client_template)

ready = ->

  clientAutocomplete()

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

  $("body").on "click", ".add-new-client-project-btn", (e) ->
    e.preventDefault()
    $("#add_client_modal").modal('show')
  #   e.preventDefault()
  #   clientAutocomplete()

$(document).ready(ready);
$(document).on('page:change', ready);