#= require jquery
#= require jquery_ujs
#= require underscore
#= require action_button
#= require_tree .

$ ->
  form_id = '#form_id'
  model_name = 'model_name'
  pick_from = 'model_ids_'
  $('#magic_button').action_button(form_id, pick_from)
