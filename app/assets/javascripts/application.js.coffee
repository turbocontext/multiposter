#= require jquery
#= require jquery_ujs
#= require underscore
#= require action_button
#= require_tree .

$ ->
  destroy_form_id = '#mass_destroy_form'
  $('#mass_destroy_button').action_button(destroy_form_id)

  create_message_form_id = '#create_message_form'
  $('#create_message_button').action_button(create_message_form_id)
  $("#mark_all").click (ev) ->
    if $(this).attr("checked")
      $("input[name^='model_ids']").attr("checked", true)
    else
      $("input[name^='model_ids']").attr("checked", false)

  ids = ['facebook_common', 'facebook_community_common', 'twitter_common']
  for id in ids
    $('body').on 'keydown', "##{id}", (element) ->
      name = $(element.target).attr('id').split('_common')[0]
      $(".#{name}_message textarea").val($(element.target).val())
