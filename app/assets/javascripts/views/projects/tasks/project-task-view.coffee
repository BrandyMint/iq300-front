Widget = require 'views/base/widget'

class window.ProjectTaskView extends Widget
  init: =>
    super
    @status = $(" > section .description").data "status"
    @listElement = @el.parent "ul"

  bindings: =>

    @taskBodyEl = $ " > section", @el
    @updateElClassFromStatus()
    @positionLinks = $ " > .settings .position a", @taskBodyEl
    @positionLinks.click @changePosition
    @actionButtons = $ "li.action", @taskBodyEl
    @actionButtons.click @doAction

    @taskLink = $ ".task-title", @taskBodyEl
    @taskLink.unbind 'click'
    @taskLink.click @changeLocation

    newTaskFormEl = $ " > .new-subtask-form", @el
    if newTaskFormEl
      @addForm = new ProjectTaskForm newTaskFormEl
      @addForm.setParentComponent @
      @subtasksContainer = $ "> ul", @el
      @addForm.setResultContainer @subtasksContainer
      @addBtn = $  "a.add", @taskBodyEl
      @addBtn.unbind 'click'
      @addBtn.click @_toggleAddForm

    editTaskFormEl = $ " > .edit-task-form", @el
    if editTaskFormEl
      @editForm = new ProjectTaskForm editTaskFormEl
      @editForm.setResultContainer @taskBodyEl
      @editForm.setParentComponent @
      @editBtn = $  "li.edit", @taskBodyEl
      @editBtn.unbind 'click'
      @editBtn.click @_toggleEditForm

  _toggleEditForm: (ev)=>
    @editForm.toggle()
    ev.preventDefault()

  _toggleAddForm: (ev)=>
    @addForm.toggle()
    ev.preventDefault()

  updateElClassFromStatus: =>
    newStatus = $(".description", @taskBodyEl).data "status"
    unless newStatus == @status
      @el.removeClass @status
      @el.addClass newStatus
      @status = newStatus

  onEditSuccess: (positionChanged=false)=>
    $("> section", @el).hide()
    $("> section", @el).fadeIn()
    if positionChanged
      $(window).trigger('project-tasks:position-changed')

  onCreateSuccess: (subtask=false)=>
    $("> section", @el).hide()
    $("> section", @el).fadeIn()
    @listElement.removeClass "zero-element" if subtask

  listElement: =>
    @el.parent "ul"

  onFormShow: =>
    $("> section", @el).hide()

  onFormClose: =>
    $("> section", @el).show()

  changePosition: (ev)=>
    ev.preventDefault()
    link = $ ev.currentTarget
    $.ajax
      url: link.prop "href"
      type: link.data "method"
      success: @refreshList
      error: window.errorHandler
      beforeSend: =>
        @sending = true
        @el.addClass('is-loading')
      complete: =>
        @sending = false
        @el.removeClass('is-loading')
    false

  refreshList: =>
    $(window).trigger('project-tasks:position-changed')

  unbinndings: =>
    @addBtn.unbind 'click' if @addBtn
    @editBtn.unbind 'click' if @editBtn
    @positionLinks.unbind 'click'
    @actionButtons.unbind 'click'
    @addForm.unbindings() if @addForm
    @editForm.unbindings() if @editForm

  router: =>
    window.tasksRouter

  changeLocation: (ev)=>
    target = $ ev.currentTarget
    url = target.data "href"
    window.location = url

  doAction: (ev)=>
    return false if @el.hasClass 'is-loading'
    target = $ ev.currentTarget
    unless target.data('confirmation') == undefined
      confirm = window.confirm target.data('confirmation')
    else
      confirm = true
    if confirm
      $.ajax
        type: "POST"
        url: target.data "url"
        data:
          _method: target.data "method"
        success: @processAction
        error: window.errorHandler
        beforeSend: =>
          @sending = true
          @el.addClass('is-loading')
        complete: =>
          @sending = false
          @el.removeClass('is-loading')

    ev.preventDefault()

  processAction: (response, status, xhr) =>
    if response == "destroyed"
      @unbinndings()
      @taskBodyEl.fadeOut "normal", =>
        @el.remove()
    else
      @taskBodyEl.hide()
      @taskBodyEl.html response
      @taskBodyEl.fadeIn()
      @bindings()

app.initializer.addComponent "ProjectTaskView"
