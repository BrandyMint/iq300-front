DocumentBaseForm = require('views/documents/document-base-form')

class window.DocumentForm extends DocumentBaseForm

  bindings: =>
    @attachmentFile = $ "input[type='file']", @form
    @attachmentTitle = $ 'input.attachment-title', @form
    @attachmentDesc = $ "textarea", @form
    @infoText = $('.info span.attachment-size', @form)
    @submitBtn = $ "input[type='submit']", @form
    @submitBtn.hide()

    @attachmentFile.change (e) =>
      filename = @attachmentFile.val().replace(/^.*[\\\/]/, '')
      maxSize = @form.data('max-size') * 1024 * 1024
      attachmentSize = document.getElementById('attachment_file').files[0]?.size
      file_name_without_extension = filename.replace(/.[^.]+$/,'')
      if file_name_without_extension == ''
        file_name_without_extension = filename
      @attachmentTitle.val( file_name_without_extension )
      if filename
        @submitBtn.show()
        if attachmentSize < maxSize
          @submitBtn.removeAttr("disabled")
          @infoText.removeClass("error")
        else
          @infoText.addClass("error")
          @submitBtn.attr("disabled", true)
      else
        @infoText.removeClass("error")
        @submitBtn.hide()

    IQ300.Plugin.use 'jquery-autosize', =>
      @attachmentDesc.autosize()

  formSubmit: (e)=>
    e.stopPropagation()
    unless @attachmentFile.val() == ''
      @form.submit()
    e.preventDefault()

app.initializer.addComponent 'DocumentForm', 'document-form', (obj)=>
  window.docForm = obj