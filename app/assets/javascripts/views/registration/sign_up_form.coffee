EmailInput = require 'views/registration/inputs/email_input'
NameInput = require 'views/registration/inputs/name_input'
ConfirmPasswordInputs = require 'views/registration/inputs/confirm_password_inputs'

class window.SignUpForm
  ui:
    emailInput: "input[type='email']"
    firstNameInput: "input#user_profile_attributes_first_name"
    lastNameInput: "input#user_profile_attributes_last_name"
    passwordInput: ".password"
    btnSubmit: "input[type='submit']"

  constructor: (el) ->
    @$el = $(el)

    @_setUi()
    @validateFields()
    @bindings()

  bindings: =>
    @$el.bind 'change', @validateFields
    @emailInput.bind 'validate', @validateSubmitForm
    @firstNameInput.bind 'validate', @validateSubmitForm
    @lastNameInput.bind 'validate', @validateSubmitForm
    @passwordInput.bind 'validate', @validateSubmitForm

  validateFields: =>
    @emailInput.validate()
    @firstNameInput.validate()
    @lastNameInput.validate()
    @passwordInput.validate()

  validateSubmitForm: =>
    if @emailInput.isValid and @firstNameInput.isValid and
      @lastNameInput.isValid and @passwordInput.isValid
        @btnSubmit.attr('disabled', false)
    else
      @btnSubmit.attr('disabled', true)

  _setUi: =>
    @emailInput = new EmailInput($(@ui.emailInput, @$el))
    @firstNameInput = new NameInput($(@ui.firstNameInput, @$el))
    @lastNameInput = new NameInput($(@ui.lastNameInput, @$el))
    @passwordInput = new ConfirmPasswordInputs($(@ui.passwordInput, @$el))
    @btnSubmit = $(@ui.btnSubmit, @$el)

app.initializer.addComponent 'SignUpForm', 'sign-up-form'