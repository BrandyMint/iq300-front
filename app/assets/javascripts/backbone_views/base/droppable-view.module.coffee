View = require "backbone_views/base/view"
DraggableView = require "backbone_views/base/draggable-view"

class DroppableView extends View
  droppable: (options={})=>
    el = options.el || @$el
    @droppableTarget = el
    defaultOptions =
      hoverClass: "drop-area"
      accept: @_canDrop
      greedy: true
    options = _.extend(options, defaultOptions)
    options.drop = @_didDrop

    IQ300.Plugin.use 'jquery-ui-draggable-droppable', =>
      IQ300.Plugin.use 'jquery-ui-touch-punch', =>
        el.droppable options

        el.data 'view', @
        el.data 'collection', @collection
        el.addClass 'droppable'

  _didDrop: (ev, ui)=>
    unless ui.helper.hasClass 'is-dropped'
      ui.helper.addClass 'is-dropped'
      draggable =  ui.draggable
      draggableView = draggable.data 'view'
      draggableModel = draggableView.model
      srcCollection =  draggableView.collection
      dstCollection = @collection
      if srcCollection?
        srcCollection.remove draggableModel
      if dstCollection?
        dstCollection.add draggableModel
      @didDrop draggableView

  _canDrop: (el)=>
    dragableView = $(el).data 'view'
    if not dragableView or not (dragableView instanceof DraggableView)
      container = $(el).closest '.droppable'
      dragableView = container.data('view')  if container
      if not dragableView or not (dragableView instanceof DraggableView)
        return false
    dragableView.canDrop(@) and @canDrop(dragableView)

  canDrop: (draggableView)=>
    return true

  didDrop: (draggableView)=>

module.exports = DroppableView