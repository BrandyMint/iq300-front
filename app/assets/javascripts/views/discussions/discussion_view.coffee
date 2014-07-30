Widget = require 'views/base/widget'
CommentsList = require 'views/comment/comments_list'
CommentsForm = require 'views/comment/comments_form'

class window.DiscussionView extends Widget
  config:
    refreshListOnInit: true
    formElSelector: '.main-form'
    listElSelector: '.comments-list'

  init: =>
    @mainForm = new CommentsForm($(@config.formElSelector, @el), @)
    @commentsList = new CommentsList($(@config.listElSelector, @el), { discussion: @ })
    @refreshList() if @config.refreshListOnInit

  bindings: =>
    @mainForm.bind 'comment:created', @commentsList.addComment
    @bind 'comment:mentioned', @insertMention

  insertMention: (mentioned)=>
    @el.parent().ScrollTo()
    @mainForm.insertMention mentioned

  refreshList: =>
    setTimeout =>
      @commentsList.refresh()
    ,0

app.initializer.addComponent 'DiscussionView', 'discussion'