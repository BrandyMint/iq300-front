class window.UserPhoneEditor
  constructor: (el) ->
    @el = $ el
    @el.on 'hidden', @restoreModal
    @newPhoneBindings()

  newPhoneBindings: =>
    @form = $ '.phone-change-body form', @el
    @errors = $ '.modal-errors', @el
    @curPhone = $ '#user-current-phone'
    @submitBtn = $ "input[type='submit']", @form
    @submitBtnSendingVal = app.i18n.t('users.edit.geting_code')
    @submitBtnDefVal = @submitBtn.val()
    @submitBtn.click @newPhone


  restoreModal: =>
    if typeof(@newPhoneHtml) != "undefined"
      @el.html(@newPhoneHtml)
      @newPhoneBindings()

  newPhoneConfirmation: (e)=>
    e.preventDefault()
    $.ajax
      type: @cForm.attr 'method'
      url: @cForm.attr 'action'
      dataType: 'json'
      data: @cForm.serialize()
      beforeSend: () =>
        @errors.html('')
        @cSubmitBtn.val(@cSubmitBtnSendingVal)
        @cForm.addClass('is-loading')
      success: (data)=>
        if data.status == 'error'
          @errors.html(data.text)
        else
          @el.modal('hide')
          @curPhone.text(data.phone)
          @cForm.removeClass('is-loading')
          new window.Flash(data.text)
      complete: () =>
        @cSubmitBtn.val(@cSubmitBtnDefVal)
        @cForm.removeClass('is-loading')

  initConfirmation: =>
    @cForm = $ '.phone-confirm-body form', @el
    @cSubmitBtn = $ "input[type='submit']", @cForm
    @cSubmitBtnSendingVal = app.i18n.t('users.edit.confirm_code')
    @cSubmitBtnDefVal = @cSubmitBtn.val()
    @errors = $ '.modal-errors', @el
    $("input[type='text']", @cForm).focus()
    @cSubmitBtn.click @newPhoneConfirmation


  confirmPhoneForm: (data)=>
    @submitBtn.val(@cSubmitBtnDefVal)
    @form.removeClass('is-loading')
    @newPhoneHtml = @el.html()
    @el.html(data)
    @initConfirmation()

  newPhone: (e) =>
    e.preventDefault()
    $.ajax
      type: @form.attr 'method'
      url: @form.attr 'action'
      dataType: 'json'
      data: @form.serialize()
      beforeSend: () =>
        @errors.html('')
        @submitBtn.val(@submitBtnSendingVal)
        @form.addClass('is-loading')
      success: (data) =>
        if data.status == 'error'
          @errors.html(data.text)
        else
          @confirmPhoneForm(data.html)
      complete: () =>
        @submitBtn.val(@submitBtnDefVal)
        @form.removeClass('is-loading')

app.initializer.addComponent "UserPhoneEditor"