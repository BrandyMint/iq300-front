Checkbox = require 'views/shared/checkbox'

class window.NiceCheck
  constructor: (el)->
    @$el = $ el
    @setUi()
    @init()
    @bindings()

  init: =>
    @$el.addClass('checked') if @checkbox.checked

  setUi: =>
    $checkboxEl = $("input[type='checkbox']", @el)
    @checkbox = new Checkbox($checkboxEl, checked: $checkboxEl.prop('checked'))


  bindings: =>
    @checkbox.bind 'checked unchecked', =>
      @$el.toggleClass("checked")

app.initializer.addComponent 'NiceCheck', 'niceCheck'