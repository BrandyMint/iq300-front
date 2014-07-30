Input = require 'views/registration/inputs/input'

class ConfirmPasswordInputs extends Input
  passwordReg: /^.{6,}$/

  ui:
    passwordInput: "input#user_password"
    confirmPasswordInput: "input#user_password_confirmation"

  initialize: =>
    @_setUi()

  validate: =>
    password = @passwordInput.val()
    confirmPassword = @confirmPasswordInput.val()
    if @passwordReg.test(password) and password is confirmPassword
      @valid()
    else
      @invalid()
    @trigger 'validate'

  valid: =>
    @passwordInput.addClass('verification')
    @isValid = true

  invalid: =>
    @passwordInput.removeClass('verification')
    @isValid = false

  _setUi: =>
    @passwordInput = $(@ui.passwordInput, @$el)
    @confirmPasswordInput = $(@ui.confirmPasswordInput, @$el)

module.exports = ConfirmPasswordInputs