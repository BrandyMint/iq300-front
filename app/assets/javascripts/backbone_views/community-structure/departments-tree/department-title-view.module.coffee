DraggableView = require "backbone_views/base/draggable-view"

class DepartmentTitleView extends DraggableView
  template: "department-title"
  autoRender: false

  initialize: =>
    super
    @parent = @options.parent

  render: =>
    super
    unless @model.isRoot()
      @draggable(scope: 'departments')
    @

  domBindings: =>
    destroyBtn = @$ ".destroy-department"
    destroyBtn.click @destroyDepartment   #TODO waiting for jquery ui draggable
    @$input = @$ 'input'
    editBtn = @$ 'span'
    editBtn.dblclick @activateEditInput

  activateEditInput: =>
    @$input.css opacity: 1
    @$el.addClass 'edit-mode'
    @$input.val @model.get('title')
    @$input.focus()
    @$input.bind 'focusout', @onEditCompleted
    @$input.keypress (event)=>
      @onEditCompleted() if event.keyCode == 13

  onEditCompleted: =>
    if @model.set('title', @$input.val(), validate: true)
      @deactivateEditInput()
    else
      @displayErrorMessage(app.i18n.t(@model.validationError))
      @$input.focus()

  deactivateEditInput: =>
    @$input.unbind 'focusout'
    @$input.animate opacity: 0.25, =>
      @$el.removeClass 'edit-mode'
      @refresh()

  displayErrorMessage: (message)=>
    container = $("<span class='flash-error'></span>").html(message)
    container.purr()

  destroyDepartment: =>
    if confirm app.i18n.t('views.community_structure.departments_tree.department_title.are_you_sure')
      @model.delayedDestroy()

  afterDragStart: =>
    $('.department-root-drop-area').toggleClass('drop-area')

  afterDragFinish: =>
    $('.department-root-drop-area').toggleClass('drop-area')

module.exports = DepartmentTitleView
