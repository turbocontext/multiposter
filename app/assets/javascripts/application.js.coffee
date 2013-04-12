#= require jquery
#= require jquery_ujs
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

  ids =[
    'facebook_common_text',
    'facebook_community_common_text',
    'twitter_common_text'
  ]
  for id in ids
    $('body').on 'keyup', "##{id}", (element) ->
      name = $(element.target).attr('id').split('_common')[0]
      $(".#{name}_message textarea").val($(element.target).val())

  ids = [
    'facebook_common_link',
    'facebook_community_common_link',
    'twitter_common_link'
  ]
  for id in ids
    $('body').on 'keyup', "##{id}", (element) ->
      name = $(element.target).attr('id').split('_common')[0]
      $(".#{name}_message input[type=text]").val($(element.target).val())
