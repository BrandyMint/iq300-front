View = require 'backbone_views/base/view'
Checkbox = require 'views/shared/checkbox'

class TEdUserView extends View
  tagName:'li'
  template: 'team_editor/ted_user'
  checkboxSelector: 'input[type=checkbox]'

  initialize: (options)->
    super
    @community = options.community
    @team = options.team
    @group = options.group

  bindings: =>
#    @community.bind "departments:selected", @_onSelectDepartment

  render: =>
    super
    @bindings()
    @

  domBindings: =>
    @$el.unbind('click')
    @$el.click @_onClickUser
    @checkbox ||= new Checkbox(@$el.find(@checkboxSelector), checked: @model.isInTeam())

  _onClickUser: (ev)=>
    ev.preventDefault()
    ev.stopPropagation()
    @checkbox.toggleCheck()
    if @model.isInTeam()
      @team.removeUser(@model)
    else
      @team.addUser(@model, @group)

module.exports = TEdUserView