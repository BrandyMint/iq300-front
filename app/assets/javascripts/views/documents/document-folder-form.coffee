DocumentBaseForm = require('views/documents/document-base-form')

class window.DocumentFolderForm extends DocumentBaseForm

  bindings: =>
    @form.submit @formSubmit
    @submitButton = $ "input[type='submit']", @form
    @resetButton = $ "input[type='reset']", @form
    @submitButtonVal =  @submitButton.val()
    @titleInput = $ "input#attachment_title", @form
    @communityInput = $ "select#attachment_community_id", @form
    @folderInput = $ "input#attachment_share_parent_id", @form

  formSubmit: (e)=>
    e.preventDefault()
    data = @form.serialize()
    $.ajax
      type: 'post'
      url: @form.attr "action"
      data: data
      dataType: "json"
      beforeSend: =>
        @disableSubmit()
        @form.append("<div class='spinner-box is-loading'></div>")
      complete: =>
        @enableSubmit()
        $('div.is-loading', @form).remove()
      success: (response, status, xhr) =>
        @clear()
        @submitButton.parent().append("<span class='flash'>#{response['message']}</span>")
        flashMessage = $ 'span.flash', @form
        flashMessage.fadeIn =>
          flashMessage.fadeOut 3000, =>
            $('body').click()
            flashMessage.remove()
        window.documentsList.router().setParam "folder", "roots,my,all"
        window.documentsList.refreshNewElements()
      error: window.errorHandler

  enableSubmit: =>
    @submitButton.val @submitButtonVal
    @submitButton.removeAttr 'disabled'

  disableSubmit: =>
    @submitButton.val @submitButton.data 'wait'
    @submitButton.attr 'disabled','disabled'

  clear: =>
    @titleInput.val ''
    @communityInput.val ''
    @communityInput.trigger "change"
    @folderInput.val ''
    @folderInput.trigger 'change'

app.initializer.addComponent 'DocumentFolderForm', 'folder-form', (obj)=>
  window.docFolderForm = obj