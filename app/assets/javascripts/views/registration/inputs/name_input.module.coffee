Input = require 'views/registration/inputs/input'

class NameInput extends Input
  namesReg: /^[а-яА-ЯёЁA-Za-z][а-яА-ЯёЁA-Za-z_-]+$/i
  namesLength: { range: [2..50] }

  validate: =>
    name = @el.val()
    if @namesReg.test(name) and name.length in @namesLength['range']
      @valid()
    else
      @invalid()
    @trigger 'validate'

module.exports = NameInput