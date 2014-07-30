class window.DatetimeField
  constructor: (el)->
    @el = $ el
    @dateField = $ "input.date-input", @el
    @timeField = $ "input.time-input", @el
    @originalField = $ "input[type='hidden']", @el

    window.IQ300.Plugin.use "moment", =>
      @dateField.bind "change", @updateHiddenField
      @timeField.bind "change", @updateHiddenField
      window.IQ300.Plugin.use "masked-input", =>
        @timeField.mask "99:99", {placeholder:"0"}

  updateHiddenField: =>
    unless @validateTime(@timeField.val())
      alert("Неверный формат времени")
      @timeField.focus()
      return
    date = moment("#{@dateField.val()} #{@timeField.val()}", "DD.MM.YYYY HH:mm")
    @originalField.val date.format("YYYY-MM-DD HH:mm")

  validateTime: (time)=>
    regExp = /^\s*([01]?\d|2[0-3]):?([0-5]\d)\s*$/
    time.match(regExp) isnt null

app.initializer.addComponent DatetimeField,
  role: "datetime-field"