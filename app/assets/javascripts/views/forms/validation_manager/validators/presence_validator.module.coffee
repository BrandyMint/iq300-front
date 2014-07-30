class PresenceValidator

  constructor: (value)->
    @value = value

  validate: =>
    string = _.trim(@value)
    if string == '' then 'Не может быть пустым' else null

module.exports = PresenceValidator