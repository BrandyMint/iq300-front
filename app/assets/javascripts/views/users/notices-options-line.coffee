class window.NoticesOptionsLine
  constructor: (el) ->
    @el = $ el
    @trigger = $ '.trigger', @el
    @relatedOptions = $ "input[type='checkbox']:not(.trigger)", @el
    @trigger.click @toggleOptionsState
    @toggleOptionsState()

  toggleOptionsState: =>
    if @trigger.is(":checked")
      @relatedOptions.removeAttr "disabled"
    else
      @relatedOptions.attr "disabled", true

app.initializer.addComponent "NoticesOptionsLine"