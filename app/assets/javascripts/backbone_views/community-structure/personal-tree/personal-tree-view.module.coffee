MembershipsContracts = require "collections/memberships-contracts"
View = require "backbone_views/base/view"

class PersonalTreeView extends View
  template: "personal-tree"
  className: "personal-tree"

  show: (worker)=>
    @model = worker
    @refresh()
    $(window).trigger "cs:state", "personal-tree"

  domBindings: =>
    if @model
      @$(".close-btn").click =>
        $(window).trigger "cs:state", "base"

      TaskRulesColumnView = require "backbone_views/community-structure/personal-tree/task-rules-column-view"
      WorkerView = require "backbone_views/community-structure/base/worker-view"

      @targetView.unbind() if @targetView
      @targetView = new WorkerView
        model: @model
        disableDrag: true
      @targetView.render().$el.appendTo @$(".target")
      @$('.target-column a.department-title').html @model.department().get('title')

      @masterColumn.unbind() if @masterColumn
      @masterColumn = new TaskRulesColumnView
        model: @model
        collection: new MembershipsContracts(@model.masters())
        el: @$ ".masters-column"
        title: app.i18n.t('views.community_structure.personal_tree.view.suppliers')
        taskRule: "master"

      @slaveColumn.unbind() if @slaveColumn
      @slaveColumn = new TaskRulesColumnView
        model: @model
        collection: new MembershipsContracts(@model.slaves())
        el: @$ ".slaves-column"
        title: app.i18n.t('views.community_structure.personal_tree.view.executors')
        taskRule: "slave"

      app.initializer.initializeOnly "Expander", @el

module.exports = PersonalTreeView