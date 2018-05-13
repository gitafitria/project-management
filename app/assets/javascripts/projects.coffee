ready = ->

  $("body").on "click", "#add_project_milestone_btn", (e) ->
    e.preventDefault();
    form_wrapper = $("#project_form")
    milestone_list_wrapper = form_wrapper.find("#project_milestone_list")
    add_milestone_template = form_wrapper.find("#add_milestone_template").html()
    modal_wrapper = form_wrapper.find("#add_project_milestone")

    milestone = {}
    milestone["index"] = (new Date).getTime()

    milestone_input = modal_wrapper.find("#milestone_item").find(".project_milestone_form")
    milestone_input.each (index) ->
      milestone[$(this).attr("name")] = $(this).val()

    milestone_list_wrapper.append(Mustache.render(add_milestone_template, milestone))

    milestone_input.val("")
    modal_wrapper.modal('hide')

$(document).ready(ready);
$(document).on('page:change', ready);