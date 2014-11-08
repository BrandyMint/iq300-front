window.NewProject ||= {}

((app) ->
  listItem = $('@notification-list-item-block')
  listItem.each ->
    counter = $(@).find('[role*="notification-list-group-item-counter"]')
    closeBtn = $(@).find('[role*="notification-list-group-item-close"]')
    $(@).on 'click', (e) ->
      $(@).find('[role*="notification-list-item-group"]').collapse('toggle')
      counter.toggle()
      closeBtn.toggle()
    $(@).find('a').on 'click', (e) ->
      e.stopPropagation()
    counter.on 'click', (e) =>
      e.preventDefault()
      e.stopPropagation()
      item = $(@)
      item.find('[role*="notification-list-item-group"]').collapse('show')
      #toggleClass('notification-list-item-group-hidden')
      counter.toggle()
      closeBtn.toggle()
    closeBtn.on 'click', (e) =>
      e.preventDefault()
      e.stopPropagation()
      item = $(@)
      item.find('[role*="notification-list-item-group"]').collapse('hide')
      #toggleClass('notification-list-item-group-hidden')
      counter.toggle()
      closeBtn.toggle()


)(window.NewProject ||= {})


