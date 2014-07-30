EmailInput = require 'views/registration/inputs/email_input'
UserPreferences = require 'services/user_preferences'

class window.SignInForm
  ui:
    emailInput: "input[type='email']"
    passwordInput: "input#user_password"
    btnSubmit: "input[type='submit']"

  constructor: (el) ->
    @$el = $(el)

    @_setUi()

    memory_email = UserPreferences.get('email')
    @emailInput.el.val(memory_email) if memory_email

  _setUi: =>
    @emailInput = new EmailInput($(@ui.emailInput, @$el))
    @passwordInput = $(@ui.passwordInput, @$el)

app.initializer.addComponent 'SignInForm', 'sign-in-form'