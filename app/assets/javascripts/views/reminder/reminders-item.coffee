class window.RemindersItem
  constructor: (el)->

    @el = $ el
    @deleteButton = $ '.destroy-reminder', @el
    @url = @deleteButton.attr('href')

    @bindings()

  bindings: =>
    @deleteButton.on 'click', @destroyReminder

  destroyReminder: (event)=>
    event.preventDefault()
    $.ajax
      type: 'post',
      url: @url,
      dataType: 'html',
      data:
        _method: 'delete'
      success: (response) =>
        @el.parent().html(response)
        app.initializer.initialize(@el.parent().html)
        $('a.remind.popup-window').removeClass 'active'
      error: window.errorHandler

app.initializer.addComponent 'RemindersItem'