class ProjectTasksTab
  ui:
    anchor: 'a'

  constructor: (el) ->
    _.extend @, Backbone.Events

    @el = $(el)

    @_setUi()

    @url = @anchor.attr('href')

    @bindings()

  bindings: =>
    @anchor.bind 'click', @activate

  _setUi: =>
    @anchor = $(@ui.anchor, @el)

  activate: (event) =>
    event.preventDefault()
    @trigger('activate', @)
    @el.addClass('active')

module.exports = ProjectTasksTab