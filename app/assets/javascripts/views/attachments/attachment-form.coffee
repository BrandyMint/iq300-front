class window.AttachmentForm
  constructor: (el)->
    @el = $ el
    @form = $ 'form', @el

    @attachmentFile = $ "input[type='file']", @form
    @attachmentTitle = $ 'input.attachment-title', @form
    @attachmentDiscription = $ 'textarea#attachment_description', @form
    @attachmentCategories = $ '#categories', @form
    @attachmentFields = $ '.attachment-data', @form
    @infoText = $('.info span.attachment-size', @form)
    @submitBtn = $ "input[type='submit']", @form
    @existAttachmentDefaultName = @form.data('exist-attachment-default-name')
    @attachmentHidden = $ 'input.link-attachment-id', @el

    @submitBtn.hide()
    @submitBtn.click @formSubmit
    @notifyUsers = $ ".select-unselect-checkboxes input[type='checkbox']", @form
    @notifyAllLink = $ "a.select-all-notify-users", @form
    @unselectAllLink = $ "a.unselect-all-notify-users", @form

    @attachmentHidden.on 'change', @updateAttachmentLabel

    @notifyAllLink.click (e)=>
      e.preventDefault()
      @notifyUsers.attr 'checked', true


    @unselectAllLink.click (e)=>
      e.preventDefault()
      @notifyUsers.attr 'checked', false

    @attachmentFile.change (e) =>
      @showAttachmentFields()
      maxSize = @form.data('max-size') * 1024 * 1024
      attachmentSize = document.getElementById('attachment_file').files[0]?.size
      filename = @attachmentFile.val().replace(/^.*[\\\/]/, '')
      file_name_without_extension = filename.replace(/.[^.]+$/,'')
      if file_name_without_extension == ''
        file_name_without_extension = filename
      @attachmentTitle.val( file_name_without_extension )
      if filename
        @submitBtn.show()
        if attachmentSize < maxSize
          @enableAddAttachment()
        else
          @disableAddAttachment()
      else
        @infoText.removeClass('error')
        @submitBtn.hide()

  enableAddAttachment: =>
    @infoText.removeClass('error')
    @submitBtn.removeAttr("disabled")

  disableAddAttachment: =>
    @infoText.addClass('error')
    @submitBtn.attr("disabled", true)

  updateAttachmentLabel: (e)=>
    existAttachmentName = $('.add-existed .select2-chosen', @form).text()
    if existAttachmentName != @existAttachmentDefaultName
      @enableAddAttachment()
    if e.added == undefined
      @showAttachmentFields()
    else
      @hideAttachmentFields()
      @submitBtn.show()

  formSubmit: (e)=>
    e.stopPropagation()
    unless @attachmentFile.val() == '' && @attachmentHidden.select2('data') == undefined
      @form.submit()
    e.preventDefault()

  showAttachmentFields: =>
    @attachmentHidden.select2('data', null)
    @attachmentFields.show()

  hideAttachmentFields: =>
    @resetAttachmentFields()
    @attachmentFields.hide()

  resetAttachmentFields: =>
    @attachmentFile.val('')
    @attachmentTitle.attr 'disabled', true
    @attachmentDiscription.attr 'disabled', true
    @attachmentCategories.select2('data', null)

app.initializer.addComponent 'AttachmentForm', 'attachment-form'