#= require jquery
#= require jquery_ujs
#= require underscore
#= require action_button
#= require_tree .

$ ->
  form_id = '#mass_destroy_form'
  $('#mass_destroy_button').action_button(form_id)

  $("#mark_all").click (ev) ->
    if $(this).attr("checked")
      $("input[name^='model_ids']").attr("checked", true)
    else
      $("input[name^='model_ids']").attr("checked", false)
