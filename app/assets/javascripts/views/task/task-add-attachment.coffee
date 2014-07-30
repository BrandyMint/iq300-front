class window.TaskAttachments

  constructor: (el) ->
    @$el = $(el)
    @$form = $('form', @$el)
    @$files = $('.files', @$el)
    @url = @$form.attr 'action'
    @inputFile = $('input[type="file"]', @$el)
    @$addAttachmentBtn = $('[role="new-attachment-button"]', @$el)

    @bindings()

  bindings: =>
    @$addAttachmentBtn.bind 'click', (e) =>
      @inputFile.click()

    @inputFile.bind 'change', (event) =>
      @$form.submit()

    @$form.bind 'submit', @createAttachment

  createAttachment: =>
    attachmentMaxSize = @$form.data('attachment-max-size')
    attachmentMaxSizeInBytes = attachmentMaxSize * 1000 * 1000
    attachmentSize = @inputFile[0].files[0]?.size
    if attachmentSize and attachmentSize < attachmentMaxSizeInBytes
      data = new FormData @$form[0]
      $.ajax
        url: @url,
        type: 'post'
        data: data
        cache: no
        contentType: false
        processData: false
        beforeSend: @disableSubmit
        complete: @enableSubmit
        success: (data) =>
          @$files.append(data)
          app.initializer.initializeOnly('TaskAttachment', @$files)
          new PNotify({
            text: app.i18n.t('tasks.upload.success'),
            type: 'success',
            opacity: .9
          })
        error: =>
          new PNotify({
            text: app.i18n.t('tasks.upload.error'),
            type: 'danger',
            opacity: .9
          })
      no
    else if attachmentSize > attachmentMaxSizeInBytes
      new PNotify({
        text: app.i18n.t('tasks.upload.max_file_size_error', attachmentMaxSize),
        type: 'warning',
        opacity: .9
      })
      no
    else
      no

  enableSubmit: =>
    window.q = @$addAttachmentBtn
    @$addAttachmentBtn.find('.title').text(app.i18n.t('tasks.upload.add'))
    @$addAttachmentBtn.removeAttr "disabled"

  disableSubmit: =>
    @$addAttachmentBtn.find('.title').text(app.i18n.t('tasks.upload.addition'))
    @$addAttachmentBtn.attr('disabled', true)

app.initializer.addComponent TaskAttachments,
  role: 'task-attachments'