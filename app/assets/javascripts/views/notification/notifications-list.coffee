WidgetList = require 'views/base/widget_list'
NotificationItemActions = require 'views/notification/notification_item_actions'

class window.NotificationsList extends WidgetList
  init: =>
    super
    @filters = ["folder", "sort", "ntype", "search"]
    @readSelectedLink = $ "a.link.read-selected-notices"
    @readAllLink = $ "a.link.read-all-notices"
    @expandAllLink = $ "a.link.expand-all-notices"
    @readSelectedLink.click  @readSelectedNotices
    @readAllLink.click  @readAlldNotices
    @expandAllLink.click  @expandAll

  readAlldNotices: (ev)=>
    ev.preventDefault()
    url = $(ev.currentTarget).prop "href"
    unreadNotices = $ ".notification-item.new", @el
    $.ajax
      url: url
      dataType: 'json'
      type: 'POST'
      data: {'_method': 'PUT'}
      success: =>
        @_setCheckBox $("input.read", @el), checked=false, disabled=true
        unreadNotices.removeClass "new"
        @refreshCounters()
      error: window.errorHandler

  expandAll: (ev)=>
    ev.preventDefault()
    target = $ "span", $(ev.currentTarget)
    newText = target.data "opposite-title"
    target.data "opposite-title", target.text()
    target.text newText
    target.toggleClass "expanded"
    expandableNotices =  if target.hasClass "expanded"
      $ ".notification-item.has-children:not(.expanded)", @el
    else
      $ ".notification-item.has-children.expanded", @el
    for notice in expandableNotices
      notice.click()

  readSelectedNotices: (ev)=>
    ev.preventDefault()
    @readSelectedCheckboxes()

  readSelectedCheckboxes: (selectedCheckboxes=null)=>
    url = @readSelectedLink.prop "href"
    unless selectedCheckboxes
      selectedCheckboxes = $ "input.read.checked", @el
    ids =_.map selectedCheckboxes, (item)->
      $(item).data "id"
    if ids.length > 0
      $.ajax
        url: url
        dataType: 'json'
        type: 'POST'
        data:
          '_method': 'PUT'
          ids: ids.join()
        success: =>
          @_setCheckBox selectedCheckboxes, checked=false, disabled=true
          _.each selectedCheckboxes, (item)=>
            $(item).parent().parent().removeClass "new"
          @refreshCounters()
        error: window.errorHandler

  getParams: =>
    @params = _(@params || {}).extend {active: @activeLine}
    for filter in @filters
      @params[filter] = window.notificationsRouter.getParam filter
    @params

  refreshCounters: =>
    @filter().refresh()
    new MenuItem(menuList.items.first()).refresh()

  updateActiveItemClass: (status)=>
    activeNotification = $ '.active', @el
    activenotifications.removeClass 'new' if activeNotification && status != 'new'

  bindings: =>
    super
    @notifications = $ ".notification-item", @el
    @notifications.unbind "click"
    @notifications.click @showSublist
#    @notifications.unbind 'mouseenter mouseleave'
#    @notifications.bind 'mouseenter mouseleave', @onHover
#    @readLabels = $ "i.icon-ok", @el
#    @readLabels.unbind "click"
#    @readLabels.click @toggleReadCheckbox

    @links = $ ".notification-item a", @el
    @links.unbind "click"
    @links.click @stopPropogationAndRedirect
    for item in $("[role='action-buttons']", @el)
      notificationItemActions = new NotificationItemActions(item)
      notificationItemActions.bind 'btn:clicked', @readNotificationById

  readNotificationById: (notificationId) =>
    $.ajax
      url: @readAllLink.prop('href')
      dataType: 'json'
      type: 'POST'
      data:
        '_method': 'PUT'
        ids: notificationId
      success: =>
        $(".notification-item[data-id='#{notificationId}']").removeClass('new')
        @refreshCounters()
      error: window.errorHandler

  stopPropogationAndRedirect: (ev)=>
    ev.stopPropagation()
    true

#  toggleReadCheckbox: (ev)=>
#    ev.stopPropagation()
#    ev.preventDefault()
#    target = $ ev.currentTarget
#
#    notification = target.parent().parent().parent()
#    id = notification.data "id"
#    input = $ "input#notification-#{id}", notification
#    @_toggleCheckbox input
#    @_syncRelatedCheckboxes notification, input.hasClass("checked")

  _syncRelatedCheckboxes: (notification, value)=>
    if notification.hasClass "has-children"
      parent = $ "> ul.sublist", notification
      unless notification.hasClass "expanded"
        notification.click()
    else
      if notification.parent().hasClass "sublist"
        parent = notification.parent().parent()
    if parent
      relatedCheckboxes = $ "input.read", parent
      for checkbox in relatedCheckboxes
        @_setCheckBox $(checkbox), value


  _toggleCheckbox: (checkbox)=>
    unless checkbox.prop "disabled"
      checkbox.toggleClass "checked"
      value = checkbox.hasClass "checked"
      checkbox.prop "checked", value

  _setCheckBox: (checkbox, value, disable=false)=>
    checkbox.prop "checked", value
    if value
      checkbox.addClass "checked"
    else
      checkbox.removeClass "checked"
    if disable
      checkbox.prop "disabled", true


  onHover: (ev)=>
    ev.stopPropagation()
    @notifications.removeClass "hovered"
    if ev.type == "mouseenter"
      $(ev.currentTarget).addClass "hovered"

  showSublist: (ev)=>
    if window.webkitNotifications && window.htmlNotifier
      window.htmlNotifier.checkPermission(ev)
    ev.stopPropagation()
    target = $ ev.currentTarget
    if target.hasClass "has-children"
      sublist = $ "> ul.sublist", target
      unless sublist.hasClass "loaded"
        @loadSublist target, sublist
      target.toggleClass "expanded"
    @read target
    ev.preventDefault()

  read: (notification)=>
    if notification.hasClass "new"
      @readSelectedCheckboxes  $ "input.read:not([disabled])", notification


  loadSublist: (root, container)=>
    id = root.data "id"
    container.append("<div class='spinner-box is-loading'></div>")
    checkBox = $ "input.read", root
    $.ajax
      url: "/notifications"
      data:
        node: id
        folder: @router().getParam "folder"
      type: "GET"
      success: (response)=>
        data = $ response
        if checkBox.prop "checked"
          @_setCheckBox $("input.read", data), true
        container.html data
        @read root
        @bindings()
        container.addClass 'loaded'


  filter: =>
    window.notificationsFilter

  router: =>
    window.notificationsRouter

  showNotification: (ev)=>
    target = $ ev.currentTarget
    @clearSelection()
    target.addClass "active"
    @activeLine = target.data "id"
    window.notificationsRouter.navigate "notifications/#{@activeLine}", true

  clearSelection: =>
    @notifications.removeClass "active"

app.initializer.addComponent "NotificationsList", 'notifications-list-column', (obj)=>
  window.notificationsList = obj
