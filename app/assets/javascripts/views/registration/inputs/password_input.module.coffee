Input = require 'views/registration/inputs/input'

class PasswordInput extends Input
  passwordReg: /^.{6,}$/

  validate: =>
    password = @el.val()
    if @passwordReg.test(password)
      @valid()
    else
      @invalid()
    @trigger 'validate'

module.exports = PasswordInput