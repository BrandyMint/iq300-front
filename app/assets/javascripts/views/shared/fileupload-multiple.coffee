class window.FileuploadMultiple

  constructor: (el) ->
    @el = $(el)
    attachmentMaxSize = parseInt( $('#file_max_size', @el).text(), 10 ) * 1000 * 1000
    @infoText = $('.info span.attachment-size', @el)
    @addNewAttachmentBtn = $('.add_nested_fields', @el)
    @formSubmitBtn = $ "input[type='submit']"

    $(document).on 'nested:fieldAdded:attachments', (e) =>
      field = e.field
      field.hide()
      fileInput = field.find('input[type=file]')
      label = field.find('label')
      fileInput.on('change', (event) =>
        field.show()
        addedAttachmentId = $('li.fields input[type="file"]', @el).last().attr('id')
        addedAttachmentLabel = $("li.fields label[for = #{addedAttachmentId}]", @el)
        fileEl = $ "##{addedAttachmentId}", @el
        addedAttachmentSize = fileEl[0].files[0]?.size
        if addedAttachmentSize > attachmentMaxSize
          @disableAddAttachment(addedAttachmentLabel)
        labelText = _.last($(event.currentTarget).val().split('\\'))
        addedAttachmentSizeInMb = addedAttachmentSize / 1000 / 1000
        if addedAttachmentSizeInMb
          labelText += " (#{addedAttachmentSizeInMb.toFixed(2)} Mb)"
        else
        label.text(labelText)
      ).trigger('click')

    $(document).on 'nested:fieldRemoved:attachments', (e) =>
      e.field.remove()
      if $('li.fields:visible input[type="file"]', @el).length
        lastAttachmentId = $('li.fields:visible input[type="file"]', @el).last().attr('id')
        lastAttachmentSize = $("##{lastAttachmentId}", @el)[0].files[0]?.size
        if lastAttachmentSize < attachmentMaxSize
          @enableAddAttachment()
      else
        @enableAddAttachment()

  enableAddAttachment: =>
    @infoText.removeClass("error")
    @formSubmitBtn.removeAttr('disabled')
    @addNewAttachmentBtn.show()

  disableAddAttachment: (attachmentLabel) =>
    attachmentLabel.addClass("error")
    @infoText.addClass("error")
    @formSubmitBtn.attr("disabled", true)
    @addNewAttachmentBtn.hide()

app.initializer.addComponent('FileuploadMultiple', 'multiple-file-upload')
