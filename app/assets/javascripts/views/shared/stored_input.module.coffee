UserPreferences = require 'services/user_preferences'

class StoredInput
  config:
    rootKey: 'forms'

  constructor: (el, formKey) ->
    @$el = $(el)
    @formKey = formKey
    @$fields = $('input[type="text"], textarea', @$el)
    @initializeStore()
    @restoreFormFields()
    @bindings()

  initializeStore: =>
    formsData = @getFormsData()
    formsData ?= {}
    @storeForms(formsData)

  restoreFormFields: =>
    for field in @$fields
      $field = $ field
      fieldName = $field.prop('name')
      formFields = @getFormFields()
      $field.val(formFields[fieldName]) if fieldName of formFields

  bindings: =>
    for field in @$fields
      $(field).on 'keyup', @onFieldChange

  onFieldChange: (e) =>
    $field = $ e.currentTarget
    fieldName = $field.prop('name')
    fieldValue = $field.val()
    @storeField(fieldName, fieldValue)

  storeField: (fieldName, fieldValue) =>
    formFields = @getFormFields()
    formFields[fieldName] = fieldValue
    storedForms = @getFormsData()
    storedForms[@formKey] = formFields
    @storeForms(storedForms)

  getFormFields: =>
    formsData = @getFormsData()
    formsData[@formKey] ?= {}

  getFormsData: =>
    UserPreferences.get(@config.rootKey)

  storeForms: (data) =>
    UserPreferences.set(@config.rootKey, data)

  clearAll: =>
    formsData = @getFormsData()
    delete formsData[@formKey]
    @storeForms(formsData)

module.exports = StoredInput