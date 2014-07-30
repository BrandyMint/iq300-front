Widget = require 'views/base/widget'

class window.SubtaskView extends Widget

  bindings: =>
    @url = @el.data 'url'
    @ended = @el.hasClass('done')

    @subtaskCheckbox = $ ':checkbox', @el
    @subtaskCancelLink = $ '.cancel', @el
    @subtaskCheckbox.click @forceAcceptSubtask
    @subtaskCancelLink.click @cancelSubtask


  forceAcceptSubtask: (e)=>
    if !@ended and @subtaskCheckbox.is(':checked')
      confirmed = confirm @subtaskCheckbox.data('confirmation')
      if confirmed
        $.ajax
          type: 'put',
          url: @url,
          data:
            do: 'force_accept'
          success: =>
            @el.addClass('done')
            @subtaskCheckbox.attr('disabled', true)
          error: window.errorHandler
      else
        @subtaskCheckbox.attr('checked', false)
    false

  cancelSubtask: (e)=>
    if !@ended and confirm @subtaskCancelLink.data('confirmation')
      $.ajax
        type: 'put',
        url: @url,
        data:
          do: 'cancel'
        success: =>
          @el.addClass('done')
          @subtaskCheckbox.attr('disabled', true)
        error: window.errorHandler
    false

app.initializer.addComponent 'SubtaskView', 'subtask-view'