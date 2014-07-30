class App
  constructor: ->
    @initializers = {}
    @initializer = require('services/initializer')
    @i18n = require('services/i18n')

  start: =>
    Backbone.history.start(
      pushState:true
      silent: true
    )
    @initializer.initialize()

window.app = new App

window.t = window.app.i18n.t

$ ->
  app.start()