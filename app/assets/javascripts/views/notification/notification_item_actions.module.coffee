class NotificationItemActions

  constructor: (el)->
    _.extend @, Backbone.Events

    @el = $(el)
    @actionLink = $ "[role='action']", @el
    @notificationId = @el.data('notification-id')
    @bindings()

  bindings: =>
    @actionLink.bind 'click', @processAction

  processAction: (ev)=>
    @trigger 'btn:clicked', @notificationId
    ev.preventDefault()
    link = $ ev.currentTarget
    url = link.prop "href"
    if link.data('confirmation')
      confirm = window.confirm link.data('confirmation')
    if confirm || !link.data('confirmation')
      @el.addClass('is-loading')
      $.ajax
        url: url
        method: 'POST'
        success: (response) =>
          @el.fadeOut 'normal', =>
            @el.parent().addClass('no-action-buttons')
            @el.remove()
          new PNotify({ text: response['notice'], type: 'info' })
        error: window.errorHandler

module.exports = NotificationItemActions