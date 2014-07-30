Widget = require 'views/base/widget'

class window.NotificationsFilter extends Widget
  bindings: =>
    @expanders = $ '.expander', @el
    @folders = $ ".folder", @el
    @expanders.click @expand
    @folders.click @filterNotifications
    @counters = $ '.counter', @el
    @refreshCounters()
    $(window).bind 'search-started', =>
      @folders.removeClass 'active'

  isActive: =>
    false

  refresh: =>
    @refreshCounters()

  refreshCounters: =>
    menuElem = window.menuList.items.filter('.tasks')
    menuItem = new MenuItem menuElem
    menuItem.refresh()
    toRefreshCounters = @counters.filter ":not(.related)"
    for counter in toRefreshCounters
      @syncRemoteCounter($(counter))

  syncRemoteCounter: (counter)=>
    params = counter.data 'params'
    window.countersManager.push "notifications",
      data: params
      success: (count) =>
        @drawCounter counter, count
        sourceType = counter.attr 'type'
        if sourceType
          for relatedCounter in @counters.filter("[source~='#{sourceType}']")
            @drawRelatedCounter $(relatedCounter)

  drawCounter: (counter, val) ->
    if val == 0 && !counter.hasClass 'categories'
      counter.fadeOut()
    else
      counter.fadeIn()
    counter.text val
    if counter.parent().hasClass('expanded')
      counter.hide()

  drawRelatedCounter: (relatedCounter)=>
    sum = 0
    for source in relatedCounter.attr('source').split(' ')
      text = $(@counters.filter("[type=#{source}]")).text()
      unless text == ''
        sum += parseInt text
    @drawCounter relatedCounter, sum

  expand: (e) =>
    target = $ e.currentTarget
    target.parent().toggleClass 'expanded'
    counter = target.parent().children('.counter').first()
    counter.toggle()
    counter.hide() if counter.text() == '0'

  filterNotifications: (e) =>
    target = $ e.currentTarget
    activeFolder = target.data "folder"
    @folders.removeClass 'active'
    target.addClass('active')
    if activeFolder
      window.notificationsRouter.setParam "folder", activeFolder
    else
      window.notificationsRouter.deleteParam "folder"
    window.notificationsList.active = false
    window.notificationsList.setDefaultPage()
    window.notificationsList.refresh()
    $('#container').removeClass('show-filters show-list show-navigation')
    window.Notification.requestPermission()
    false

app.initializer.addComponent "NotificationsFilter", "notifications-filter", (obj) =>
  window.notificationsFilter = obj

