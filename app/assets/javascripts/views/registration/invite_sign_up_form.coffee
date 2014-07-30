NameInput = require 'views/registration/inputs/name_input'
ConfirmPasswordInputs = require 'views/registration/inputs/confirm_password_inputs'

class window.InviteSignUpForm
  ui:
    firstNameInput: "input#user_profile_attributes_first_name"
    lastNameInput: "input#user_profile_attributes_last_name"
    passwordInput: ".password"
    btnSubmit: "input[type='submit']"

  constructor: (el) ->
    @$el = $(el)

    @_setUi()
    @bindings()

  bindings: =>
    @firstNameInput.bind 'validate', @validateSubmitForm
    @lastNameInput.bind 'validate', @validateSubmitForm
    @passwordInput.bind 'validate', @validateSubmitForm

  validateSubmitForm: =>
    if @firstNameInput.isValid and @lastNameInput.isValid and @passwordInput.isValid
      @btnSubmit.attr('disabled', false)
    else
      @btnSubmit.attr('disabled', true)

  _setUi: =>
    @firstNameInput = new NameInput($(@ui.firstNameInput, @$el))
    @lastNameInput = new NameInput($(@ui.lastNameInput, @$el))
    @passwordInput = new ConfirmPasswordInputs($(@ui.passwordInput, @$el))
    @btnSubmit = $(@ui.btnSubmit, @$el)

app.initializer.addComponent 'InviteSignUpForm', 'invite-sign-up-form'