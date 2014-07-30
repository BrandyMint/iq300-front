class window.TaskAttachment

  constructor: (el) ->
    @$el = $(el)
    @removeAttachmentLink = $ '[role="remove-attachment"]', @el

    @bindings()

  bindings: =>
    @removeAttachmentLink.unbind 'click'
    @removeAttachmentLink.bind 'click', @removeAttachment

  removeAttachment: (e) =>
    e.preventDefault()
    $removelLink = $ e.currentTarget
    url = $removelLink.attr("href")
    $.ajax
      url: url
      type: "DELETE"
      success: =>
        $removelLink.parent().remove()
        new PNotify({
          text: app.i18n.t('tasks.upload.removed'),
          type: 'success',
          opacity: .9
        })

app.initializer.addComponent TaskAttachment,
  role: 'task-attachment'