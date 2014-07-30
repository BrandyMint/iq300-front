class window.RemindersForm
  constructor: (el)->
    #vars
    @el = $ el
    @url = @el.attr('action')

    #components
    @submitButton = $ "input[type='submit']", @el
    @submitButtonVal = @submitButton.val()
    @bindings()

  bindings: =>
    @submitButton.on 'click', @formSubmit

  disableSubmit: =>
    @submitButton.val @submitButton.data('wait')
    @submitButton.attr 'disabled','disabled'

  enableSubmit: =>
    @submitButton.val @submitButtonVal
    @submitButton.removeAttr 'disabled'

  formSubmit: (event)=>
    event.preventDefault()
    data = @el.serialize()
    $.ajax
      type: 'post',
      url: @url,
      dataType: 'html',
      data: data,
      beforeSend: @disableSubmit,
      complete: @enableSubmit,
      success: (response) =>
        @el.parent().html(response)
        app.initializer.initialize(@el.parent().html)
        $('a.remind.popup-window').addClass 'active'
      error: window.errorHandler


app.initializer.addComponent 'RemindersForm'