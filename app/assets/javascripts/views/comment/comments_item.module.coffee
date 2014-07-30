class CommentsItem
  constructor: (el, list)->
    @el = $(el)
    @list = list
    @isRoot = @el.data 'root'
    @isLast = @el.data 'last'
    @authorMentionName = @el.data 'author'
    @answerBtn = $('.answer', @el)
    @deleteBtn = $('.delete', @el)
    @bindings()

  bindings: =>
    @answerBtn.bind 'click', @toggleAnswerForm
    @deleteBtn.bind 'click', @deleteComment

  toggleAnswerForm: (event)=>
    @list.discussion.trigger 'comment:mentioned', @authorMentionName

  deleteComment: (event)=>
    target = $ event.currentTarget
    url = target.data 'url'
    confirm = window.confirm target.data('confirmation')
    if confirm
      $.ajax
        type: 'post',
        url: url,
        data:
          _method: 'delete'
        success: =>
          @el.remove()
    event.preventDefault()

module.exports = CommentsItem