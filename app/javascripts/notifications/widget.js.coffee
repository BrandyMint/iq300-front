window.NotificationsWidget ||= {}

((app) ->
  $(document).ready ->
    btn = $('@notifications-widget-button')
    widget = $('@notifications-widget-popover')
    item = $('@notifications-widget-popover-item')
    closeBtn = $('@notifications-widget-popover-close')
    backBtn = $('@notifications-widget-popover-back')
    notifications = $('@notifications-widget-popover-notifications')
    messages = $('@notifications-widget-popover-messages')

    #widget.fadeIn()
    messages.hide()
    notifications.show()
    if widget?.length > 0 && btn?.length > 0
      setWidgetPosition(widget, btn)

    btn.on 'click', (e) ->
      e.preventDefault()
      widget
        .fadeToggle()

    $('body').on 'click', (e) ->
      hideWidget widget, messages, notifications

    closeBtn.on 'click', (e) ->
      hideWidget widget, messages, notifications

    widget.on 'click', (e) ->
      e.stopPropagation()
    btn.on 'click', (e) ->
      e.stopPropagation()

    item.on 'click', (e) ->
      messages.show()
      notifications.hide()

    backBtn.on 'click', (e) ->
      notifications.show()
      messages.hide()

  setWidgetPosition = (widget, btn) ->
    left = btn.position().left + btn.width() - widget.width()/2
    top = btn.position().top + btn.height()
    widget.css('left', left + 'px').css('top', top + 'px')

  hideWidget = (widget, messages, notifications) ->
    widget.fadeOut()
    messages.hide()
    notifications.show()


)(window.NotificationsWidget ||={})
