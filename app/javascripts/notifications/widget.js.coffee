window.NotificationsWidget ||= {}

((app) ->
  $(document).ready ->
    btn = $('@notifications-widget-button')
    widget = $('@notifications-widget-popover')
    closeBtn = $('@notifications-widget-popover-close')

    widget.fadeIn()
    setWidgetPosition(widget, btn)

    btn.on 'click', (e) ->
      e.preventDefault()
      widget
        .fadeToggle()

    $('body').on 'click', (e) ->
      widget.fadeOut()

    closeBtn.on 'click', (e) ->
      widget.fadeOut()

    widget.on 'click', (e) ->
      e.stopPropagation()
    btn.on 'click', (e) ->
      e.stopPropagation()

  setWidgetPosition = (widget, btn) ->
    left = btn.position().left + btn.width() - widget.width()/2
    top = btn.position().top + btn.height()
    widget.css('left', left + 'px').css('top', top + 'px')


)(window.NotificationsWidget ||={})
