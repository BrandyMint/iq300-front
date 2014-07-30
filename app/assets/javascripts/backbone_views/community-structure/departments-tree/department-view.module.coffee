DroppableView = require "backbone_views/base/droppable-view"
DepartmentTitleView = require "backbone_views/community-structure/departments-tree/department-title-view"
DepartmentsListView = require "backbone_views/community-structure/departments-tree/departments-list-view"
DepartmentWorkersView = require "backbone_views/community-structure/departments-tree/department-workers-view"

class DepartmentView extends DroppableView
  tagName: "li"
  template: "department"
  className: "department"


  initialize: =>
    super
    @children = []
    @parent = @options.parent
    @parent.children.push @ if @parent


  render: =>
    @tumblers()[@model.id] = {} unless @tumblers()[@model.id]
    super
    @childrenTumbler.prop "checked", @tumblers()[@model.id]["childs"]
    @titleTumbler.prop "checked", !@tumblers()[@model.id]["title"]
    @droppable(scope: 'departments')
    @listenTo @model, "change", @onModelChange
    @listenTo @model, "removed:children", @updateChildrenCounter
    @

  onModelChange: =>
    return true if @model.hasChanged('title')

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
    @

  tumblers: =>
    window.structureView.departmentsTumblers

  domBindings: ()=>
    @children = []
    @collection = @model.children()
    @childrenTumbler = @$ "input[type=checkbox].toggle.#{@model.id}"
    @titleTumbler = @$ "input[type='checkbox'].department-toggle.#{@model.get('id')}"
    @childrenTumbler.bind "change", =>
      @tumblers()[@model.id]["childs"] = @childrenTumbler.is(":checked")

    @titleTumbler.bind "change", =>
      @tumblers()[@model.id]["title"] = !@titleTumbler.is(":checked")

    @titleTumbler.prop "checked", !@tumblers()[@model.id]["title"]
    @childrenTumbler.prop "checked", @tumblers()[@model.id]["childs"]

    # departments list
    @departmentsList = new DepartmentsListView
      collection: @collection
      model: @model
      parent: @
      el: @$("ol.children.#{@model.id}")
    @departmentsList.render()
#    @departmentsList.bind "refresh", @updateDepartmentChildrenCounter
    @children.push @departmentsList

    # workers list
    @departmentWorkersView = new DepartmentWorkersView
      model: @model,
      collection: @model.crew(),
      el: @$(".d-card-body.#{@model.id}")
      parent: @
    @children.push @departmentWorkersView
    @departmentWorkersView.render()
    @departmentWorkersView.bind "dropped", @unfold

    # title
    collection = if @parent
      @parent.collection
    else
      @collection
    @departmentTitleView = new DepartmentTitleView
      model: @model,
      collection:collection,
      parent: @,
      el: $(".d-card-title.#{@model.get('id')}", @$el)
    @departmentTitleView.render()
    @children.push @departmentTitleView

    @updateChildrenCounter()
    super

  canDrop:(draggableView)=>
    if draggableView instanceof DepartmentTitleView
      dragedDepartmentId = draggableView.model.id

      # exclude dragging parent into child and child into parent
      @model.id != dragedDepartmentId &&
        @$el.parents( "ol.children.#{dragedDepartmentId}").length == 0  &&
          @model.children().where({id: dragedDepartmentId}).length == 0
    else
      false


  updateChildrenCounter: =>
    childCount = @model.childrenCount()
    if childCount == 0
      if @model.isRoot()
        @parent.$el.addClass 'zero-children'
      @$el.addClass 'zero-children'
    else
      @$el.removeClass 'zero-children'
      counter = $ ".counter.#{@model.get('id')}", @$el
      counter.text childCount

  didDrop: (draggableView)=>
    dragedDepartment = draggableView.model
    return unless dragedDepartment
    dragedDepartment.setParent @model


  unfold: =>
    @titleTumbler.prop "checked", false


module.exports = DepartmentView