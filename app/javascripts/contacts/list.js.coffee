window.ContactsList ||= {}

((app) ->
  $(document).ready ->
    $input = $('@contacts-list-search-input')
    $reset = $('@contacts-list-search-reset')

    $input.on 'keydown', (e) ->
      if $(@).val().length > 0
        $reset.show()
      else
        $reset.hide()


)(window.ContactsList ||= {})
