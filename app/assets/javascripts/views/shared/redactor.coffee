class window.Redactor
  constructor: (el)->
    @el = $ el
    IQ300.Plugin.use 'redactor', @init

  init: =>
    @el.redactor()

app.initializer.addComponent 'Redactor'