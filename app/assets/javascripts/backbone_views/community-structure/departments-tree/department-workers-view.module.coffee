DroppableView = require "backbone_views/base/droppable-view"
WorkerView = require "backbone_views/community-structure/base/worker-view"

class DepartmentWorkersView extends DroppableView
  autoRender: false

  bindings: =>
    @droppable(scope: 'workers')
    @listenTo @collection, "add remove change:restore change:boss", @onCollectionChange
    @listenTo window.structureView, 'workers:loaded', @onCollectionChange

  draw: =>
    @children = []
    @bossContainer = $ ".boss-card.#{@model.id}", @$el
    @workersContainer = $ ".workers.#{@model.id}", @$el
    if @collection.isEmpty()
      @bossContainer.append $("<div class='memberships-contract empty'></div>")
    else
      @collection.each (worker)=>
        if worker.isBoss()
          container  = @bossContainer
          count = @collection.size() - 1
        else
          container  = @workersContainer
          count = null
        view = new WorkerView model:worker, workersCount:count, collection:@collection
        el = view.render().el
        container.append el
        @children.push view

    if @addedWorker
      window.changeJobView.hidePopup()
      workerEditBtn = $ "i.icon-reorder[data-model-id=\'#{@addedWorker.id}\']", @$el
      @trigger "dropped"
      workerEditBtn.trigger "click"
      workerEditBtn.parent().addClass 'popup-opened'
    @addedWorker = null

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
    @bossContainer.empty()
    @workersContainer.empty()
    @draw()
    @

  canDrop:(draggableView)=>
    draggableView instanceof WorkerView

  didDrop: (draggableView)=>
    worker = draggableView.model


    return unless worker
    if worker.job() == undefined || worker.job().get('department_id') != @model.id
      worker.setJob @model.defaultJob()
      @addedWorker = worker
      @trigger "dropped"
      @parent.unfold() if @parent

module.exports = DepartmentWorkersView