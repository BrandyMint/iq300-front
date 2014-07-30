class MicroNews
  ui:
    closeButton: "[role='close-button']"

  constructor: (el) ->
    @$el = $(el)

    @url = @$el.data('url')

    @_setUi()
    @bindings()

  bindings: =>
    @$closeButton.bind 'click', @read

  read: =>
    @$el.fadeOut('slow')
    $.ajax
      type: 'POST'
      url: @url

  _setUi: =>
    @$closeButton = $(@ui.closeButton, @$el)

app.initializer.addComponent MicroNews,
  role: 'micro-news'
