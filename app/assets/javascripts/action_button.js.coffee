$.fn.action_button = (form_id, pick_from, trigger_count = 1) ->
  @each ->
    $(this).on 'click', ->
      a = $("input[id=#{pick_from}]:checked:visible").map (i, el) -> return $(el).val()

      if a.length >= trigger_count
        checked_values = _.toArray(a).join(',')
        $(form_id).find("input[id*=model_ids]").val(checked_values)
        $(form_id).submit()
      else
        false
