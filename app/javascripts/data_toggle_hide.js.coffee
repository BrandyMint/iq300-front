window.DataToggleHide ||= {}

((app) ->
  $(document).ready ->
    toggle = $('[data-toggle*="toggle"]')
    toggle.each ->
      target = $(@).data('target') || $(@).attr('href')
      $(@).on 'click', (e) ->
        e.preventDefault()
        $(target).toggle()

)(window.DataToggleHide ||= {})
