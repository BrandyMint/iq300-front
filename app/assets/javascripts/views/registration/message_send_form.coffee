UserPreferences = require 'services/user_preferences'

class window.MessageSendForm
  ui:
    emailInput: "input[type='email']"

  constructor: (el) ->
    @$el = $(el)

    @_setUi()
    @bindings()

  bindings: =>
    memory_email = UserPreferences.get('email')
    @emailInput.val(memory_email) if memory_email
    @emailInput.bind 'change', @changeMemoryEmail

  changeMemoryEmail: =>
    UserPreferences.set('email', @emailInput.val())

  _setUi: =>
    @emailInput = $(@ui.emailInput, @$el)

app.initializer.addComponent 'MessageSendForm', 'message-send-form'