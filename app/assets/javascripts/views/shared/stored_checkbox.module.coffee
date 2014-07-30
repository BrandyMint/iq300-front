Checkbox = require 'views/shared/checkbox'
preferences = require 'services/user_preferences'

class StoredCheckbox

  constructor: (el, preferenceKey) ->
    _.extend @, Backbone.Events

    @$el = $(el)
    @preferenceKey = preferenceKey
    @checkbox = new Checkbox(el, checked: @_initialState())
    @bindings()

  bindings: =>
    @checkbox.bind('checked unchecked', @_storeState)

  isChecked: =>
    @checkbox.checked

  _initialState: =>
    preferences.get(@preferenceKey)

  _storeState: (checked) =>
    @trigger('changed', checked)
    preferences.set(@preferenceKey, checked)

module.exports = StoredCheckbox