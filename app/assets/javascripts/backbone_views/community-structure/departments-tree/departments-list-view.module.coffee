View = require "backbone_views/base/view"
DepartmentView = require "backbone_views/community-structure/departments-tree/department-view"

class DepartmentsListView extends View
  tagName: "ol"
  className: "children"

  initialize: =>
    super
    @children = []
    @parent = @options.parent

  render: =>
    super
    @listenTo @collection, "add remove", @onCollectionChange
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
    super
    @trigger "refresh"
    @

  domBindings: =>
    DepartmentView = require "backbone_views/community-structure/departments-tree/department-view"

    @children = []
    @parent.updateChildrenCounter() if @parent
    @collection.each (model)=>
      if model.visible()
        view = new DepartmentView(model:model, parent: @, collection:model.children())
        @$el.append view.render().el
        @children.push view
    @

module.exports = DepartmentsListView