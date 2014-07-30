class window.SmsConfirmationView
  constructor: (el)->
    @el = $ el
    @form = $  '.new-sms-code form', @el
    @messagesContainer = $ '.confirmation-messages', @el
    @url = @form.prop("action")
    @sendCodeBtn = $ 'input[name="send_code"]', @form
    @checkCodeBtn = $ 'input[name="check_code"]', @form
    @sendCodeBtn.click @sendCode
    @checkCodeBtn.click @checkCode
    @form.submit @sendCode

  sendCode: (ev)=>
    ev.preventDefault()
    @_makeAjax "send_code"

  checkCode: (ev)=>
    ev.preventDefault()
    @_makeAjax "check_code"


  _makeAjax: (param)=>
    @data = @form.serialize()
    @data += "&#{param}=1"
    $.ajax
      type: 'post',
      url: @url,
      data: @data
      success: (data, status, xhr) =>
        @messagesContainer.empty()
        @messagesContainer.hide()
        @messagesContainer.html data
        @messagesContainer.slideDown 'fast'

app.initializer.addComponent "SmsConfirmationView"
