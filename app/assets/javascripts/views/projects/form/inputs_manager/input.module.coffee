class Input
  ui:
    input: "input[role='value']"
    checkbox: "input[type='checkbox']"
    text: "span[role='text']"

  constructor: (el)->
    _.extend @, Backbone.Events

    @$el = $(el)

    @_setUi()
    @bindings()

  bindings: =>
    @$el.bind 'click', (event)=>
      event.preventDefault()
      @trigger 'click', @

  show: =>
    @$el.show()

  hide: =>
    @$el.hide()

  remove: =>
    if @isPersist()
      @checkbox.prop('checked', true)
      @hide()
    else
      @$el.remove()

  val: (value=null)=>
    if (value or value == '')
      @input.val(value)
      @text.html(value)
    else
      @input.val()

  isPersist: =>
    @$el.data('persisted') == '' or @$el.data('persisted') == true

  _setUi: =>
    @input = $(@ui.input, @$el)
    @checkbox = $(@ui.checkbox, @$el)
    @text = $(@ui.text, @$el)

module.exports = Input