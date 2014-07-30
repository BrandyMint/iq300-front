WidgetItemTabs = require 'views/base/widget_item_tabs'

class window.TaskView extends WidgetItemTabs
  init: =>
    super
    tasks = $ '[role="task"]', @el
    users = $ "[role='user']", @el
    communities = $ "[role='community']", @el
    tasks.click @changeLocation
    users.click @changeLocation
    communities.click @changeLocation
    addSubtaskBtn = $('[role="add-subtask-btn"]', @el)
    addSubtaskBtn.tooltip()

  changeLocation: (ev)=>
    target = $ ev.currentTarget
    url = target.data "href"
    window.location = url
    return no

  show: (communityId, id)=>
    @communityId = communityId
    @id = id
    @empty = false
    @active = false
    statusEl = $ 'span.task-status', @el
    status = statusEl.data 'status'
    if window.tasksList
      activeTask = $ '.active', window.tasksList.el
    if activeTask && status != 'new'
      activeTask.removeClass 'new'
      window.tasksFilter.refresh()
    @refresh =>
      @el.trigger "onShow"
      @changeChannel()

  doAction: (e) =>
    target = $ e.currentTarget
    url = target.prop("href")
    @active = false
    confirmation = target.data "confirm"
    confirmed = if confirmation then confirm(confirmation) else true
    type = if target.hasClass('delete') then 'delete' else 'put'
    if confirmed
      $.ajax
        url: url
        data: @params
        type: type
        success: (data, status, xhr)=>
          if type == 'delete'
            @processDeleteAction(data)
          else
            @draw(data)
            window.tasksFilter.refresh()
        error: window.errorHandler
        beforeSend: =>
          target.addClass 'is-loading'
        complete: =>
          target.removeClass 'is-loading'
    false

  doRefuseAction: (e)=>
    url = @refuseForm.attr('action')
    @active = false
    @params = @refuseForm.serialize()
    $.ajax
      url: url
      data: @params
      type: "PUT"
      success: (data) =>
        new window.Flash(app.i18n.t('tasks.status_notice.refuse'))
        @draw(data)
      error: window.errorHandler
    false

  getUrl: =>
    regexp = /\/\d*$/
    if @url.match regexp
      @url = @url.replace regexp, "/#{@id}" if @id
    else
      @url = "#{@url}/#{@id}"  if @id
    @url

  bindings: =>
    super
    @actionLinks = $ "[role='action']", @el
    @actionLinks.click @doAction
    @actionsField = $ "[role='actions-field']", @el
    @inputs = $ 'input', @el
    @subtasks = $ '.subtasks-list .task-item, .related-task', @el
    @subtasks.click @showSubtask
    @tabs = $('.tabnav', @el)
    @tabUrls = $ "header.tab-navigation ul.tabnav li", @el
    @tabUrls.click @showTab
    @refuseForm = $ 'form#refuse-form', @el
    @refuseFormSubmit = $ "input[type='submit']", @refuseForm
    @refuseFormSubmit.click @doRefuseAction
    @activateBindings()
    @showActionsField()
    if @isInProject()
      @closeLinks = $ "a.close-panel.mode-trigger, a.related-project", @el
      @closeLinks.addClass "mode-trigger-initialized"
      @closeLinks.click (ev)=>
        ev.stopPropagation()
        ev.preventDefault()
        @el.trigger "onClose"
        @router().navigate "/projects/#{@projectId()}",
          trigger: false
          replace: true
        false

  showActionsField: =>
    if $('.btn', @actionsField).size()
      @actionsField.show()

  showSubtask: (ev) =>
    if window.tasksList
      window.tasksList.showTask ev
    else
      target = $ ev.currentTarget
      @activeLine = target.data "id"
      communityId = target.data "community-id"
      url = "tasks/#{@activeLine}?inline=true"
      if communityId
        url = "communities/#{communityId}/#{url}"
      @router().navigate url, true

  isInProject: =>
    window.projectsView != undefined

  projectId: =>
    window.projectsView.id

  router: =>
    window.tasksRouter

  onRefreshComplete: =>
    @el.trigger "refreshed"

  showTab: (ev) =>
    target = $ ev.currentTarget
    link = $ 'a', target
    @router().navigate link.attr('href'), true

  processDeleteAction: (response)=>
    new window.Flash(response.notice)
    @router().setParam 'folder', 'templates'
    @router().setParam 'templates', 'true'
    if window.tasksList
      window.tasksList.refresh()
      window.displayMode.disableMode('view')
      window.displayMode.enableMode('list')
      window.displayMode.enableMode('filters')
    @el.trigger 'onClose'


app.initializer.addComponent "TaskView", "task-view-column", (item)->
  window.taskView = item
