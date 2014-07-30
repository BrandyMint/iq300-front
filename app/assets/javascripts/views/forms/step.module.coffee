ValidationManager = require('views/forms/validation_manager/validation_manager')

class Step
  constructor: (config)->
    @$el = $ config.element
    @position= config.position
    @name= config.name

  hide: (callback)=>
    @$el.fadeOut 'fast', =>
      callback?()

  show: (callback)=>
    @$el.fadeIn 'fast', =>
      callback?()

  isValid: =>
    validationManager = new ValidationManager(@$el)
    validationManager.isValid()

  errors: =>
    'errors text'

  translatedName: =>
    app.i18n.t("projects.form.#{@name}_step")

module.exports = Step