window.DataToggleHide ||= {}

((app) ->
  $(document).ready ->
    toggle = $('[data-toggle*="toggle"]')
    toggle.each ->
      target = $(@).data('target') || $(@).attr('href')
      $(@).on 'click', () ->
        $(target).toggle()

)(window.DataToggleHide ||= {})
