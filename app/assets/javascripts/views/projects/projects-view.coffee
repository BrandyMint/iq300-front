WidgetItemTabs = require 'views/base/widget_item_tabs'

class window.ProjectsView extends WidgetItemTabs
  ALLOWED_FILTERS: ['community_id']

  init: =>
    super
    @id = @el.data "id"

  show: (id)=>
    @id = id
    @active = false
    @showView()
    @refresh =>
      @changeChannel()

  router: ->
    window.projectsRouter

  getParams: =>
    @params = @params || {}
    for filter in @ALLOWED_FILTERS
      @params[filter] = @router().getParam filter
    @params

  bindings: =>
    super
    @scrollContainer = $ ".column-content", @el
    @tabLinks = $ "ul.project-details a", @el
    @tabLinks.click @openTab
    @projectBody = $ "div.project-body", @el
    @actionLinks = $ "section.actions a:not(.template)", @el
    @actionLinks.click @doAction
    @taskViewEl = $ ".task-view-column", @el
    if @taskViewEl
      @taskView = new TaskView @taskViewEl
      window.taskView = @taskView
      @taskViewEl.bind "onShow", @hide
      @taskViewEl.bind "onClose", @showView
    @projectTasksListEl = $ ".project-tasks-list", @el
    if @projectTasksListEl
      @projectTasksListEl.addClass "project-tasks-list-initialized"
      @projectTasksList = new ProjectTasksList @projectTasksListEl
      setTimeout =>
        @projectTasksList.refresh()
      ,0


  doAction: (ev)=>
    ev.preventDefault()
    return false if @el.hasClass 'is-loading'
    target = $ ev.currentTarget
    method = target.data('method')
    unless target.data('confirmation') == undefined
      confirm = window.confirm target.data('confirmation')
    else
      confirm = true
    if confirm
      $.ajax
        type: method.toUpperCase()
        url: target.prop "href"
        success: (response)=>
          if method == 'delete'
            @_processRemoveAction(response)
          else
            @_processAction(response)
        error: window.errorHandler
        beforeSend: =>
          @sending = true
          @el.addClass('is-loading')
        complete: =>
          @sending = false
          @el.removeClass('is-loading')
    false

  _processAction: (response)=>
    data = $ response
    @projectBody.html data
    app.initializer.initialize @projectBody
    @bindings()

  _processRemoveAction: (response)=>
    window.projectsList.refresh()
    window.displayMode.disableMode('view')
    window.displayMode.enableMode('list')

  getUrl: =>
    "#{@url}/#{@id}" if @id


  hide: =>
    @el.addClass "task-view-shown"

  showView: =>
    @el.removeClass "task-view-shown"

  openTab: (ev)=>
    ev.preventDefault()
    target = $ ev.currentTarget
    if target.hasClass "scroll"
      targetDiv = $ target.data("target"), @el
      @scrollContainer.scrollTop targetDiv.innerHeight()
    else
      targetClass = target.prop("href").split('#')[1]
      tab = $ "ul.tabnav > li.#{targetClass} > a", @el
      tab.click()


app.initializer.addComponent 'ProjectsView', 'projects-view-column', (item)->
  window.projectsView = item
