ValidableField = require('views/forms/validation_manager/validable_field')

class ValidationManager
  ui:
    validableField: "[role='validable']"

  constructor: (el)->
    @$el = el

    @_setUi()

  isValid: =>
    @validate()
    for field in @fields
      return false if not field.isValid()
    return true

  validate: =>
    field.validate() for field in @fields
    @hideErrors()
    @showErrors()

  showErrors: =>
    for field in @fields
      html = JST['templates/forms/validation_manager']({
        validations: field.errors
      })
      field.errorsIn.append(html)

  hideErrors: =>
    $("[role='errors-list']", @$el).remove()

  _setUi: =>
    @fields = []
    for el in $(@ui.validableField, @$el)
      field = new ValidableField(el)
      @fields.push(field)

module.exports = ValidationManager