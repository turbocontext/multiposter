#= require jquery
#= require jquery_ujs
#= require action_button
#= require_tree .

$ ->
  $('#mass_destroy_button').action_button('#mass_destroy_form')
  $('#create_message_button').action_button('#create_message_form')

  $("#mark_all").click (ev) ->
    if $(this).attr("checked")
      $("input[name^='model_ids']").attr("checked", true)
    else
      $("input[name^='model_ids']").attr("checked", false)

  ids =[
    'facebook_common',
    'facebook_community_common',
    'twitter_common',
    'google_oauth2_common',
    'vkontakte_common'
  ]
  for id in ids
    $('body').on 'keyup', "##{id}_text", (element) ->
      name = get_name(element.target)
      $("#{name} textarea").val($(element.target).val())

  for id in ids
    $('body').on 'keyup', "##{id}_link", (element) ->
      name = get_name(element.target)
      $("#{name} input[type=text]").val($(element.target).val())

  get_name = (element) ->
    "." + $(element).attr('id').split('_common')[0] + "_message"

  $('body').on 'click', '#individual_edit', (ev) ->
    $("#custom_messages").slideToggle()
