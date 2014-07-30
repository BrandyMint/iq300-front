class window.ServiceRequestForm
  constructor: (form)->
    @form = $ form
    @statusMessage = $ '.status-message', @form
    @form.submit @request

  request: =>
    $.ajax
      type: @form.attr 'method'
      url: @form.attr 'action'
      data: @form.serialize()
      success: (data)=>
        @statusMessage.html data
    no

app.initializer.addComponent 'ServiceRequestForm', 'service-request-form'
