View = require "backbone_views/base/view"

class DraggableView extends View
  draggable: (options={})=>

    defaultOptions =
      distance: 6
      delay: 100
      opacity: 1
      helper: "clone"
      sourceClass: "dragging-source"
      dragClass: "dragging"
      zIndex: 2200
      scroll: true


    @options = _.extend(defaultOptions, options)
    @options.start = @_dragStart
    @options.stop = @_dragStop
    @options.drag = @_didDrag

    IQ300.Plugin.use 'jquery-ui-draggable-droppable', =>
      IQ300.Plugin.use 'jquery-ui-touch-punch', =>
        @$el.draggable @options
        @$el.data 'view', @
        @$el.data 'model', @model
        @$el.data 'collection', @collection

    @scrollContainer = window.structureView.$el
    @startingScrollTop = @scrollContainer.scrollTop()


  _dragStart: (ev, ui)=>
    @startingScrollTop =  @scrollContainer.scrollTop()
    @$el.addClass  @options.sourceClass
    @$el.removeClass 'is-dropped'
    ui.helper.addClass @options.dragClass
    window.helper = ui.helper
    $(window).trigger 'drag:start'
    @afterDragStart()

  _dragStop: (ev, ui)=>
    @$el.removeClass  @options.sourceClass
    ui.helper.removeClass @options.dragClass
    @afterDragFinish()

  _canDrag: (el, event)=>
    if $(el).parents(".structure-popup").length > 0
      false
    else
      el

  _didDrag: (ev, ui)=>
    newScrollTop = @scrollContainer.scrollTop()
    if newScrollTop > @startingScrollTop
      delta = (newScrollTop - @startingScrollTop)
    else
      delta = (@startingScrollTop - newScrollTop) * -1

    unless delta == 0
      ui.position.top +=  delta

  canDrop: (droppableView)=>
    # override me
    return true

  didDrop: (draggableView, droppableView)=>
    # override me

  afterDragStart: =>
    # override me

  afterDragFinish: =>
    # override me


module.exports = DraggableView
