Widget = require 'views/base/widget'

class TasksFilter extends Widget
  bindings: =>
    @pageTitle = $ '.page-title h2'
    @expanders = $ '.expander', @el
    @folders = $ ".folder", @el
    @expanders.click @expand
    @folders.click @filterTasks
    @counters = $ '.counter:not(.categories)', @el
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
    params = counter.data "params"
    window.countersManager.push "tasks",
      data: params
      success: (count) =>
        @drawCounter counter, count
        sourceType = counter.attr 'type'
        if sourceType
          for relatedCounter in @counters.filter("[source~='#{sourceType}']")
            @drawRelatedCounter $(relatedCounter)

  drawCounter: (counter, val)->
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
        sum += parseInt(text)
    @drawCounter relatedCounter, sum

  expand: (e) =>
    e.preventDefault()
    e.stopPropagation()
    target = $ e.currentTarget
    target.parent().toggleClass 'expanded'
    counter = target.parent().children('.counter').first()
    counter.toggle()
    counter.hide() if counter.text() == '0'

  filterTasks: (e) =>
    target = $ e.currentTarget
    params = target.data "params"
    @folders.removeClass 'active'
    target.addClass('active')
    for scope in window.TASK_FOLDER_SCOPES
      if params && params[scope]
        window.tasksRouter.setParam scope, params[scope]
      else
        window.tasksRouter.deleteParam scope

    window.tasksList.active = false
    window.tasksList.setDefaultPage()
    window.tasksList.refresh()
    @pageTitle.text(@getPageTitle(params['folder'][0]))
    $('#container').removeClass('show-filters show-list show-navigation')
    false

  getPageTitle: (folder) =>
    switch folder
      when "all" then 'Актуальные задачи'
      when "inbox" then 'Входящие задачи'
      when "outbox" then 'Исходящие задачи'
      when "personal" then 'Личные задачи'
      when "archive" then 'Архив задач'
      when "favorite" then 'Избранные задачи'
      when "templates" then 'Шаблоны задач'

app.initializer.addComponent TasksFilter,
  handler: (obj) =>
    window.tasksFilter = obj
