class ProjectDiscussionsForm
  constructor: (el)->
    _.extend @, Backbone.Events

    @el = $(el)
    @url = @el.attr 'action'

    @discussionBody = $('.discussion-body', @el)
    @submitButton = $("input[type='submit']", @el)
    @submitButtonVal = @submitButton.val()

    @bindings()

  bindings: =>
    @el.submit @formSubmit

  reset: =>
    @discussionBody.val('')

  enableSubmit: =>
    @submitButton.val @submitButtonVal
    @submitButton.removeAttr 'disabled'

  disableSubmit: =>
    @submitButton.val @submitButton.data 'wait'
    @submitButton.attr 'disabled','disabled'

  formSubmit: (event)=>
    data = @el.serialize()
    @disableSubmit()
    $.ajax
      type: 'post',
      url: @url,
      data: data
      complete: @enableSubmit
      success: (response) =>
        @reset()
        @trigger 'discussion:created', response
      error: window.errorHandler
    event.preventDefault()

module.exports = ProjectDiscussionsForm
