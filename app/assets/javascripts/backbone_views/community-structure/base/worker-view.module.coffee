DraggableView = require "backbone_views/base/draggable-view"

class WorkerView extends DraggableView
  template: "worker"
  className: "memberships-contract"

  bindings: =>
    if @model
      @listenTo @model, 'change', @refresh
      unless @disableDrag
        @draggable(scope: 'workers', helper: @makeClone)

  initialize: (options)->
    super
    @onDragContainer = options.onDragContainer
    @workersCount = options.workersCount
    @disableDrag = options.disableDrag
    window.personalTree = options.personalTree
    window.isChecked = options.isChecked || false

  render: =>
    window.workersCount =  @workersCount
    super
    @bindings()
    @

  domBindings: =>
    @actionsLink = $ 'i.icon-reorder', @$el
    @actionsLink.click window.changeJobView.showPopup
    @checkbox = @$ 'input.add-remove'
    @checkbox.click =>
      event = if @checkbox.prop "checked"
        "add-clicked"
      else
        "remove-clicked"
      @model.trigger event, @model

  unbind: =>
    @stopListening()

  makeClone: =>
    clone = @$el.clone().removeAttr("id")
    if @onDragContainer
      @onDragContainer.append clone.detach()
    clone

  refresh: =>
    super

module.exports = WorkerView
