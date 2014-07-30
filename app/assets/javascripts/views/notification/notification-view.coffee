Widget = require 'views/base/widget'

class window.NotificationView extends Widget
  show: (id)=>
    @id = id
    @active = false
    @empty = false
    statusEl = $ 'span.notification-status', @el
#    window.notificationsList.updateActiveItemClass(statusEl.data 'status')
    @refresh()

  doAction: (e) =>
    target = $ e.currentTarget
    url = target.prop("href")
    @active = false
    $.ajax
      url: url
      data: @params
      type: "PUT"
      success: @draw
    false

  refresh: =>
    $.ajax
      url: @getUrl()
      data: @params
      type: "GET"
      success: @draw

  getUrl: =>
    regexp = /\/\d*$/
    if @url.match regexp
      @url = @url.replace regexp, "/#{@id}" if @id
    else
      @url = "#{@url}/#{@id}"
    @url


#app.initializer.addComponent "NotificationView", "notification-view-column", (item)->
#  window.notificationView = item
