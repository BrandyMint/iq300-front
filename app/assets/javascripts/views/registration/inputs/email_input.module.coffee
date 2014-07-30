Input = require 'views/registration/inputs/input'
UserPreferences = require 'services/user_preferences'

class EmailInput extends Input
  emailReg: /^([a-zA-Z0-9_\.\+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-\.]+)?$/

  validate: =>
    email = @el.val()
    if @emailReg.test(email) and email
      UserPreferences.set('email', email)
      @valid()
    else
      @invalid()
    @trigger 'validate'

module.exports = EmailInput