window.ContactsList ||= {}

((app) ->
  $(document).ready ->
    $input = $('@contacts-list-search-input')
    $reset = $('@contacts-list-search-reset')
    $list = $('@contacts-list-content')
    $searchList = $('@contacts-list-search')
    $invite = $('@contacts-list-invite')
    $inviteEmail = $('@contacts-list-invite-email')

    $input.on 'keyup keypress blur change', (e) ->
      if $(@).val().length > 0
        $reset.show()
        $list.hide()
        if $(@).val().match('@')?
          $searchList.hide()
          $invite.show()
          $inviteEmail.html $(@).val()
        else
          $searchList.show()
      else
        $reset.hide()
        $list.show()
        $searchList.hide()
        $invite.hide()

    $reset.on 'click', (e) ->
      e.preventDefault()
      $input.val ''
      $reset.hide()
      $list.show()
      $searchList.hide()
      $invite.hide()



)(window.ContactsList ||= {})
