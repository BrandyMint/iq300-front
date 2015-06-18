window.NotificationsList ||= {}

((app) ->
  newItemClass = 'notifications-list-item-new'
  markBtnHiddenClass = 'top-panel-btn-hidden'
  listItemBlock = $('@notification-list-item-block')
  markBtn = $('@notification-list-mark-btn')
  markBtnCounter = $('@notification-list-mark-btn-counter')
  tabBtn = $('@notification-list-tab-btn')
  updBtn = $('@notification-list-update-btn')
  $(document).ready ->
    markVisibleAsRead()
    window.Layout.appContentBlock.on 'scroll', () ->
      markVisibleAsRead()
    tabBtn.on 'click', (e) ->
      tabBtn.removeClass 'active'
      $(@).addClass 'active'
    Layout.appContentBlock.on 'scroll', () ->
      # show button if new notifications are invisible
      if $(@).scrollTop() > $(window).height()
        updBtn.addClass 'in'
      else
        updBtn.removeClass 'in' if updBtn.hasClass 'in'
    updBtn.on 'click', (e) ->
      e.preventDefault()
      Layout.appContentBlock.animate
        scrollTop: 0
      , 500

  listItemBlock.each ->
    listItem = $(@).find('[role*="notification-list-item"]')
    counter = $(@).find('[role*="notification-list-group-item-counter"]')
    closeBtn = $(@).find('[role*="notification-list-group-item-close"]')
    closeItemBtn = $(@).find('[role*="notification-list-item-close-btn"]')
    checkbox = $('@notification-list-item-checkbox')
    closeItemBtn.on 'click', (e) ->
      e.preventDefault()
      listItem.collapse('hide')

    $(@).on 'click', (e) ->
      $(@).find('[role*="notification-list-item-group"]').collapse('toggle')
      setTimeout(( ->
        counter.toggle()
        closeBtn.toggle()
      ), 500)
      setTimeout(( ->
        listItem.removeClass newItemClass
      ), 2000)
    $(@).find('a').on 'click', (e) ->
      e.stopPropagation()
    checkbox.on 'click', (e) ->
      e.stopPropagation(e)
      visibleBtn = markBtn.filter ->
        $(@).css('display') != 'none'
      hiddenBtn = markBtn.filter ->
        $(@).css('display') == 'none'
      checked = checkbox.filter( -> $(@).is(':checked') ).length
      markBtnCounter.html checked
      if (visibleBtn.first().data('mark') == 'all' && checked > 0) || (visibleBtn.first().data('mark') != 'all' && checked == 0)
        visibleBtn.addClass markBtnHiddenClass
        setTimeout(( ->
          visibleBtn.hide()
          hiddenBtn.show()
          setTimeout(( ->
            hiddenBtn.removeClass markBtnHiddenClass
          ), 150)
        ), 150)

    counter.on 'click', (e) =>
      e.preventDefault()
      e.stopPropagation()
      item = $(@)
      item.find('[role*="notification-list-item-group"]').collapse('show')
      #toggleClass('notification-list-item-group-hidden')
      setTimeout(( ->
        counter.toggle()
        closeBtn.toggle()
      ), 500)
    closeBtn.on 'click', (e) =>
      e.preventDefault()
      e.stopPropagation()
      item = $(@)
      item.find('[role*="notification-list-item-group"]').collapse('hide')
      #toggleClass('notification-list-item-group-hidden')
      counter.toggle()
      closeBtn.toggle()

  markVisibleAsRead = ->
    visibleItems = $('@notification-list-item').filter ->
      return false unless $(@).data('automark') is true
      $(@).offset().top > 0 && ($(window).height() - $(@).offset().top > 0)
    setTimeout(( ->
      visibleItems.removeClass newItemClass
    ), 3000)

)(window.NotificationsList ||= {})


