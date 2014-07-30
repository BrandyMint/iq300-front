class Checkbox
  config:
    checked: false
    disabled: false

  constructor: (el, options = {}) ->
    _.extend @, Backbone.Events

    @$el = $(el)
    @checked = options['checked'] or @config.checked
    @disabled = options['disabled'] or @config.disabled

    @$el.prop('checked', @checked)
    @$el.prop('disabled', @disabled)

    @bindings()

  bindings: =>
    @$el.bind 'click', @changeStatus

  changeStatus: (event) =>
    event.preventDefault()
    @toggleCheck()

  toggleCheck: =>
    if @checked then @uncheck() else @check()

  check: =>
    setTimeout =>
      @$el.prop('checked', true)
      @checked = true
      @trigger 'checked', true
    , 0

  uncheck: =>
    setTimeout =>
      @$el.prop('checked', false)
      @checked = false
      @trigger 'unchecked', false
    , 0

  enable: =>
    @disabled = false
    @$el.prop('disabled', false)
    @trigger 'enabled'

  disable: =>
    @disabled = true
    @$el.prop('disabled', true)
    @trigger 'disabled'

module.exports = Checkbox