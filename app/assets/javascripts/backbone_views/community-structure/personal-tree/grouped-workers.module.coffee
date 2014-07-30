View = require "backbone_views/base/view"
PersonalTreeWorkerView = require "backbone_views/community-structure/personal-tree/personal-tree-worker-view"

class GroupedWorkersView extends View
  template: "grouped-workers"
  className: "group-workers-view"

  domBindings: =>
    @workersEl = @$ '.workers'
    @collection.each (worker)=>
      view = new PersonalTreeWorkerView
        model: worker
        target: @options.target
        taskRuleType: @options.taskRuleType
      view.render().$el.appendTo @workersEl

    app.initializer.initializeOnly "Expander", @el

module.exports = GroupedWorkersView
