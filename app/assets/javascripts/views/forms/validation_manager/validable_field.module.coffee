PresenceValidator = require('views/forms/validation_manager/validators/presence_validator')

class ValidableField

  constructor: (el)->
    @$el = $(el)
    @errors = []
    @errorsIn = $(@$el.data('errors-in')) or @$el

  isValid: =>
    @validate()
    @errors.length is 0

  validate: =>
    for key, value of @_validations()
      validator = @_getValidator(key, value)
      error = validator.validate()
      @errors.push(error) if error

  _validations: =>
    allowedValidations = ['presence']
    result = {}
    for validation in allowedValidations
      result[validation] = @$el.data("v-#{validation}")
    result

  _getValidator: (validationName, validationValue)=>
    switch validationName
      when 'presence'
        new PresenceValidator(@$el.val())
      else undefined

module.exports = ValidableField