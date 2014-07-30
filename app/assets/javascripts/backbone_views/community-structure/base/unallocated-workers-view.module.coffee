DroppableView = require "backbone_views/base/droppable-view"
WorkerView = require "backbone_views/community-structure/base/worker-view"

class UnallocatedWorkersView extends DroppableView
  autoRender: false

  bindings: =>
    @listenTo @collection, "change remove add", @onCollectionChange
    @droppable(scope: 'workers')


  draw: =>
    @children = []
    @expander = $ '.expander', @$el
    @counterEl = $ 'span.counter', @$el
    @unnalocatedBtn= $ '.btn', @$el
    @workersContainer = $ '.unallocated-workers', @$el
    @drawWorkersCounter()
    if @collection.unallocated().length == 0
      @workersContainer.append $("<div class='memberships-contract empty'></div>")
    else
      @collection.unallocated().each (worker)=>
        view = new WorkerView model:worker, onDragContainer: window.structureView.$el
        el = view.render().el
        @workersContainer.append el
        @children.push view
    app.initializer.initializeOnly "Expander", @el

  render: =>
    super
    @bindings()
    @draw()
    @


  onCollectionChange: =>
    @needToRefresh = true
    setTimeout =>
      if !@parent || !@parent.needToRefresh
        @refresh()
      @needToRefresh = false
    , 0

  unbind: =>
    @stopListening()
    @unbindChildren()

  unbindChildren: =>
    _(@children).invoke "unbind"

  refresh: =>
    @unbindChildren()
    @workersContainer.empty()
    @draw()
    @trigger "refresh"
    @

  drawWorkersCounter: =>
    @workersCount = @collection.unallocated().length
    @counterEl.text @workersCount
    elements = $ 'a, .expander, i', @unnalocatedBtn
    if @workersCount > 0
      @counterEl.show()
      elements.removeClass 'zero-workers'
      @unnalocatedBtn.removeClass 'zero-workers'
    else
      @counterEl.hide()
      elements.addClass 'zero-workers'
      @unnalocatedBtn.addClass 'zero-workers'

  canDrop:(draggableView)=>
    if draggableView instanceof WorkerView
      @openWorkersList()
      true
    else
      false

  didDrop: (draggableView)=>
    dragedWorker = draggableView.model
    return unless dragedWorker
    dragedWorker.setJob null
    @refresh()

  openWorkersList: =>
    unless @expander.parent().hasClass('expanded')
      @expander.parent().addClass('expanded')
      expandable = $ @expander.data('target'), @$el
      expandable.addClass 'expanded'

#  expand: (e)=>
#    e.preventDefault()
#    e.stopPropagation()
#    target = $ e.currentTarget
#    target.parent().toggleClass 'expanded'
#    expandable = $ target.data('target'), @$el
#    expandable.toggleClass 'expanded'


module.exports = UnallocatedWorkersView
