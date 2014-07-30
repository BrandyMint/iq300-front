ProjectDiscussionInfo = require 'views/projects/discussions/project_discussion_info'

class ProjectDiscussionsView
  ROLLED_CLASS: 'rolled'

  constructor: (el, list)->
    @el = $(el)
    @list = list
    @rolled = @el.hasClass @ROLLED_CLASS
    @discussionUrl = @el.data('discussion-url')
    @discussion = undefined
    @info = new ProjectDiscussionInfo(@el, {view: @})
    @details = $('.discussion-details', @el)

  toggle: (event)=>
    event.preventDefault
    return if $(event.target).attr 'href'
    if @rolled then @unroll(event) else @roll()

  roll: =>
    @el.addClass(@ROLLED_CLASS)
    @rolled = true

  unroll: (event)=>
    return if $(event.target).attr 'href'
    @list.hideDiscussions()
    @loadDiscussion() unless @discussion
    @el.removeClass(@ROLLED_CLASS)
    @rolled = false

  loadDiscussion: =>
    $.ajax
      url: @discussionUrl
      dataType: 'html'
      type: 'GET'
      beforeSend: =>
        @el.addClass('is-loading')
      complete: (response)=>
        @el.removeClass('is-loading')
        html = $(response.responseText)
        @details.html(html)
        @details.find('.task-discussion').addClass('disable-initializer')
        @discussion = new DiscussionView(@details)

module.exports = ProjectDiscussionsView