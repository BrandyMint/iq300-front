UserPreferences = require 'services/user_preferences'
StoredInput = require 'views/shared/stored_input'

class CommentsForm
  constructor: (el)->
    _.extend @, Backbone.Events

    @el = $(el)
    @infoText = $('.info span.attachment-size', @el)
    @url = @el.attr 'action'
    @commentText = $ 'textarea', @el
    @attachmentLabel = $ '.attachment-label', @el
    @attachmentFile = $ "input[type='file']", @el
    @submitButton = $ "input[type='submit']", @el
    @resetButton = $ "input[type='reset']", @el

    @submitButtonVal = @submitButton.val()
    @attachmentLinkBtn = $ '> a.add', @el

    @storedValues = new StoredInput(@el, @el.data('discussion-key'))

    @bindings()

  bindings: =>
    @el.bind 'submit', @formSubmit

    @attachmentLinkBtn.click =>
      @attachmentFile.click()

    @attachmentFile.bind 'change', @updateAttachmentLabel
    @attachmentFile.bind 'change', @validateAttachmentFile
    @resetButton.bind 'click', @reset
    ct = @commentText
    IQ300.Plugin.use 'jquery-autosize', ->
      ct.autosize()
    new MentionsInput ct, =>
      IQ300.Plugin.use 'jquery-shiftenter', ->
        console.log("shiftener")
        ct.shiftenter
          focusClass: 'shiftenter'
          inactiveClass: 'shiftenterInactive',
          hint: '',
          metaKey: 'shift',
          pseudoPadding: '0 10'

  enableSubmit: =>
    @el.removeClass('is-loading')
    @submitButton.val @submitButtonVal

  disableSubmit: (changeText=true)=>
    @el.addClass('is-loading')
    @submitButton.val(@submitButton.data 'wait') if changeText

  focus: =>
    @commentText.focus()

  reset: =>
    @enableAddAttachment()
    @storedValues.clearAll()
    @commentText.val ''
    @attachmentFile.val ''
    @attachmentLabel.empty()
    @commentText.trigger('autosize.resize')
    false

  insertMention: (mentioned)=>
    setTimeout =>
      @commentText.focus().val "#{@commentText.val()} @#{mentioned} "
    ,0

  validateAttachmentFile: =>
    filename = @attachmentFile.val()
    maxSize = $('form#new_comment').data('file-max-size') * 1000 * 1000
    fileEl = $ "#comment_attachment_attributes_file", @el
    attachmentSize = fileEl[0].files[0]?.size
    if filename
      if attachmentSize < maxSize
        @enableAddAttachment()
      else
        @disableAddAttachment()
    else
      @enableAddAttachment()

  enableAddAttachment: =>
    @infoText.hide()
    @submitButton.removeAttr("disabled")

  disableAddAttachment: =>
    @infoText.show()
    @submitButton.attr 'disabled','disabled'

  updateAttachmentLabel: (e)=>
    target = $(e.target)
    if target.is(":file")
      val = (@attachmentFile.val() + '').split(/(\/|\\)/)
      val = val[val.length - 1]
      fileEl = $ "#comment_attachment_attributes_file", @el
      attachmentSize = fileEl[0].files[0]?.size / 1000 / 1000
      if attachmentSize
        val += "(#{attachmentSize.toFixed(2)}Mb)"
      else
        @attachmentLabel.html('')
      @attachmentLabel.html val if val
    else if e.added != undefined
      val = e.added.text
      @attachmentFile.val('')
      @attachmentLabel.html val if val
    else
      @reset()

  formSubmit: (e)=>
    return no if @submitButton.attr('disabled')
    if @commentText.val() or @attachmentFile.val()
      data = new FormData @el[0]
      $.ajax
        url: @url,
        type: 'post'
        data: data
        cache: no
        contentType: false
        processData: false
        beforeSend: @disableSubmit
        complete: @enableSubmit
        success: (response) =>
          @storedValues.clearAll()
          @trigger 'comment:created', @, response
          @focus()
        error: window.errorHandler
    no

module.exports = CommentsForm
