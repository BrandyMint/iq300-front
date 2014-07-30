View = require "backbone_views/base/view"

class PersonalTreeWorkerView extends View
  template: "personal-tree-worker"
  className: "memberships-contract"

  render: =>
    @oppositeRule = if @options.taskRuleType == "master" then "slave" else "master"
    super
    @listenTo @model, 'change', @refresh if @model
    @

  domBindings: =>
    @checkbox = @$ 'input.add-remove'
    @checkbox.click @toggle

  toggle: =>
    @model.trigger "task-rule-#{@options.taskRuleType}:change", @model

  getTemplateData: =>
    _.extend super,
      taskRuleChecked: @taskRuleIsChecked

  taskRuleIsChecked: =>
    method = "#{@oppositeRule}Ids"
    target = @options.target
    target.id in @model[method]()

module.exports = PersonalTreeWorkerView