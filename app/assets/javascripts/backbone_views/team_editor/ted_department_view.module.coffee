View = require 'backbone_views/base/view'

class TEdDepartmentView extends View
  tagName:'li'
  template: 'team_editor/ted_department'
  activeClass: 'active'
  sublistSelector: '> ul'

  initialize: (options)->
    super
    @renderSublist = options.renderSublist
    @community = options.community

  bindings: =>
    @community.bind "departments:selected", @_onSelectDepartment



  render: =>
    super
    @bindings()
    @

  domBindings: =>
    @$el.click @_onClickDepartment
    @$sublistEl = $(@sublistSelector, @$el)
    @_renderSublist() if @renderSublist && @model.children().length > 0

  _onSelectDepartment: (department)=>
    @$el.removeClass(@activeClass) unless @model == department

  _onClickDepartment: (ev)=>
    ev.preventDefault()
    ev.stopPropagation()
    @$el.toggleClass(@activeClass)
    @community.selectDepartment(@model)

  _renderSublist: =>
    @model.children().each (department) =>
      opts =
        community: @community
        model: department
        renderSublist: true
      view = new TEdDepartmentView(opts)
      @$sublistEl.append view.render().$el

  unbindings: =>
    @community.unbind "departments:selected", @_onSelectDepartment

module.exports = TEdDepartmentView