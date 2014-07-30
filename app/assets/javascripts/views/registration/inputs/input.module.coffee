class Input
  constructor: (@el) ->
    _.extend @, Backbone.Events
    @isValid = false

    @el.bind 'input', @validate
    @initialize()
    @bindings()

  initialize: =>
    #template method

  bindings: =>
    #template method

  validate: =>
    #template method

  valid: =>
    @el.addClass('verification')
    @isValid = true

  invalid: =>
    @el.removeClass('verification')
    @isValid = false

module.exports = Input