window.renderMilestoneItem = (modal_wrapper_name, index, new_record) ->
  form_wrapper = $("#project_form")
  milestone_list_wrapper = form_wrapper.find("#project_milestone_list")
  add_milestone_template = form_wrapper.find("#add_milestone_template").html()
  modal_wrapper = form_wrapper.find("#{modal_wrapper_name}")

  milestone = {}
  milestone["index"] = index

  milestone_input = modal_wrapper.find(".milestone-item").find(".project_milestone_form")
  milestone_input.each (index) ->
    milestone[$(this).attr("name")] = $(this).val()

  console.log milestone

  if new_record == true
    milestone["new_record"] = true
    milestone_list_wrapper.append(Mustache.render(add_milestone_template, milestone))
  else
    milestone["id"] = index
    milestone["new_record"] = false

    milestone_item = milestone_list_wrapper.find("#heading_milestone_#{index}").closest(".panel")
    milestone_item.replaceWith(Mustache.render(add_milestone_template, milestone))

    milestone_list_wrapper.find("#heading_milestone_#{index}").find(".edit-project-milestone-btn").attr("data-milestone", JSON.stringify(milestone))

  milestone_input.val("")
  modal_wrapper.modal('hide')

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

    edit_modal_wrapper.attr("data-milestone-id", milestone["id"])
    edit_modal_wrapper.modal('show')

  $("body").on "click", "#update_project_milestone_btn", (e) ->
    e.preventDefault()
    form_wrapper = $("#project_form")
    edit_modal_wrapper = form_wrapper.find("#edit_project_milestone")
    index = edit_modal_wrapper.data("milestone-id")

    renderMilestoneItem("#edit_project_milestone", index, false)

$(document).ready(ready);
$(document).on('page:change', ready);