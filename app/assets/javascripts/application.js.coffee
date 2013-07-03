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
    'facebook',
    'facebook_community',
    'twitter',
    'google_oauth2',
    'vkontakte'
  ]
  $('body').on 'keyup input paste', "#common_text", (element) ->
    for id in ids
      name = "." + id + "_message"
      $(name + ' textarea[name$=\\[text\\]]').val($(element.target).val())

  $('body').on 'keyup input paste', "#common_short_text", (element) ->
    for id in ids
      name = "." + id + "_message"
      $(name + ' textarea[name$=\\[short_text\\]]').val($(element.target).val())

  $('body').on 'keyup input paste', "#common_link", (element) ->
    for id in ids
      name = "." + id + "_message"
      $("#{name} input[type=text]").val($(element.target).val())

  $('body').on 'click', '#individual_edit', (ev) ->
    $("#custom_messages").slideToggle()

  $('body').on 'click', '#post_message_button', (element) ->
    $('#new_message_set').submit()

  $('body').on 'change', '#model_ids_', (ev) ->
    user_id = $(ev.target).val()
    checked = $(ev.target).is(':checked')
    url = "/social_users/#{user_id}"
    $.ajax
      url: url
      dataType: 'json'
      type: 'PUT'
      data: "social_user[checked]=#{checked}"
