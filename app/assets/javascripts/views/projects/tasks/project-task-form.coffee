Widget = require 'views/base/widget'

class window.ProjectTaskForm extends Widget
  init: =>
    @url = @el.data "url"
    @editorMode = @el.hasClass "edit-task-form"
    @subtaskForm = @el.hasClass "new-subtask-form"
    @resultElement = undefined
    @parent = undefined
    @loading = false
    @sending = false
    @el.hide()
    $(window).bind "project-task-form-opened", (ev, url) =>
      @hide() unless url == @url

  bindings: =>
    @form = $ 'form', @el
    @sending = false
    @titleInput = $ 'input#base_task_title', @form
    @form.submit @saveTask
    $("a.cancel", @el).click @hide
    IQ300.Plugin.use 'jquery-autosize', ->
      $('textarea', @form).autosize()

  unbindings: =>
    @form.unbind "submit"

  onSuccessContainer: =>
    @resultElement

  setResultContainer: (element)=>
    @resultElement = element

  setParentComponent: (comp)=>
    @parent = comp

  saveTask: (ev)=>
    ev.preventDefault()
    return false if @sending
    @positionChanged = @taskPosition != @getTaskPositionFromInput()
    $.ajax
      type: @form.prop "method"
      url: @form.prop "action"
      data: @form.serialize()
      success: @processResponse
      error: window.errorHandler
      beforeSend: =>
        @sending = true
        @el.addClass('is-loading')
      complete: =>
        @sending = false
        @el.removeClass('is-loading')

  processResponse: (response)=>
    return false unless @onSuccessContainer()
    data = $ response
    app.initializer.initialize data
    if @editorMode
      @onSuccessContainer().html data
      @parent.onEditSuccess(@positionChanged) if @parent
    else
      newTask = new ProjectTaskView data
      newTask.el.addClass "project-task-view-initialized"
      newTask.el.appendTo @onSuccessContainer()
      newTask.listElement = @onSuccessContainer()
      newTask.onCreateSuccess @subtaskForm
    @el.hide()
    @parent.bindings() if @parent

  getTaskPositionFromInput: =>
    $('input#base_task_complex_position', @el).val()

  show: (ev)=>
    return false if @loading || @visible()
    @refresh =>
      setTimeout =>
        @titleInput.focus()
      , 0
      @taskPosition = @getTaskPositionFromInput()
      $(window).trigger "project-task-form-opened", @url
      @loading = true
      @el.parent().addClass "is-loading"

  hide: (ev)=>
    return false unless @visible()
    @el.fadeOut "normal", =>
      @parent.onFormClose() if @editorMode && @parent

  onRefreshComplete: =>
    @parent.onFormShow() if @editorMode && @parent
    @el.parent().removeClass "is-loading"
    @el.fadeIn()
    @loading = false

  visible: =>
    @el.is(':visible')

  toggle: =>
    if @visible() then @hide() else @show()

app.initializer.addComponent "ProjectTaskForm"
