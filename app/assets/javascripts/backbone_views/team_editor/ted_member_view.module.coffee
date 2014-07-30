View = require 'backbone_views/base/view'

class TEdMemberView extends View
  tagName:'li'
  template: 'team_editor/ted_member'
  removeBtn: '[role=remove-btn]'
  deletionFlag: 'input[role=deletion-flag]'

  initialize: (options)->
    super
    @hidden = options.hidden
    @team = options.team

  render: =>
    super
    @

  domBindings: =>
    @$el.find(@removeBtn).click @_onDeleteClick
    @$deletionFlag = @$el.find(@deletionFlag)
    @$el.hide() if @hidden

  _onDeleteClick: (ev)=>
    @$deletionFlag.val('true')
    @$el.hide()
    @team.removeUser(@model)

module.exports = TEdMemberView