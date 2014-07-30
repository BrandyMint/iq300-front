StoredCheckbox = require 'views/shared/stored_checkbox'
ProjectTasksTab = require 'views/projects/tasks/_project_tasks_tab'
WidgetList = require 'views/base/widget_list'

class window.ProjectTasksList extends WidgetList


  ui:
    filterSelector: ".project-tasks-filter input[type='checkbox']"
    tabs: '.tabs .tab'

  init: =>
    super
    @bindedToSorting = true
    @bindedToSearch = true
    @filters = ["folder", "sort", "search"]
    newTaskFormEl = $ " > .new-task-form", @el
    @addForm = new ProjectTaskForm newTaskFormEl
    @tasksContainer = $ ".infinite-list", @el
    @addForm.setResultContainer @tasksContainer
    @addTaskBtn = $ "a.add-task", @el
    @addTaskBtn.click @addForm.toggle
    @hideFinishedTasksFilter = new StoredCheckbox($(@ui.filterSelector, @el.parent()),
      'project_tasks_filter'
    )
    @filtered = @hideFinishedTasksFilter.isChecked()
    @hideFinishedTasksFilter.bind('changed', @updateList)
    @_applyFilter()
    $(window).bind "project-tasks:position-changed", =>
      @updateList(@filtered)
    @_setUi()

  getParams: =>
    @params = _(@params || {}).extend {active: @activeLine}
    @params = _(@params).extend {"_": new Date().getTime()}
    for filter in @filters
      @params[filter] = @router().getParam filter
    @params

  getParamsStr: =>
    str=''
    for key, value of @getParams()
      if value != undefined && key != undefined
        str += "#{key}=#{value}&"
    str

  router: =>
    window.tasksRouter

  updateList: (checked)=>
    @filtered = checked
    setTimeout =>
      @_applyFilter()
      @setDefaultPage()
      @loading = true
      @refresh =>
        @loading = false
    , 0

  bindings: =>
    super
    tab.unbind('activate').bind('activate', @deactivateTabs) for tab in @tabs
#    @hoverBindings()
    if window.taskView
      window.taskView.el.bind "refreshed", =>
        $(".project-task-view").removeClass "is-loading"

  initializeData: (data)=>
    window.data = data
    for element in data
      el = $ element
      if el.hasClass "project-task-view"
        new window.ProjectTaskView(el)
        el.addClass "project-task-view-initialized"
    app.initializer.initialize data

  deactivateTabs: (activeTab)=>
    tab.el.removeClass('active') for tab in @tabs
    @url = activeTab.url
    @updateList(@filtered)

  _applyFilter: =>
    if @filtered
      @params['without_finished'] = true
    else
      delete  @params['without_finished']

  _setUi: =>
    @tabs ||= []
    @tabs.push(new ProjectTasksTab(item)) for item in $(@ui.tabs, @el)

#  hoverBindings: =>
#    paragraphs = $ ".paragraph-item", @el
#    paragraphs.unbind 'mouseover'
#    paragraphs.bind 'mouseover', @onHover
#
#
#  onHover: (ev)=>
#    ev.stopPropagation()
#    target = $(ev.currentTarget)
#    unless @hoveredItem
#      @hoveredItem = $('li.paragraph-item.hovered', @el)
#    unless target.hasClass 'hovered'
#      @hoveredItem.removeClass "hovered"
#      target.addClass "hovered"
#      @hoveredItem = target
