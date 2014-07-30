WidgetList = require 'views/base/widget_list'
CommentsItem = require 'views/comment/comments_item'

class CommentsList extends WidgetList
  config:
    withButton: true
    moreBtnDataClass: 'more-button-data'
    itemsOnPage: 10

  init: (options)=>
    super
    @bindedToSearch = true # TODO
    @discussion = options.discussion
    @comments ||= []
    @comments.push(new CommentsItem(item, @)) for item in $('.comment-item', @el)

  addComment: (form, response)=>
    html = $(response).hide()
    form.reset()
    container = @getInfiniteList()
    container.prepend(html)
    html.fadeIn(1000)
    @comments.push(new CommentsItem($(html, container), @))

  initializeData: (data)=>
    comments = []
    for item in data
      el = $ item
      if el.hasClass 'comment-item'
        comments.push(new CommentsItem(el, @))
    @comments.concat(comments)
    comments

  parseDataAndAddMoreBtn: (data, page)=>
    btnData = null
    _.each data, (item)=>
      $element = $ item
      if $element.hasClass(@config.moreBtnDataClass)
        btnData = @moreBtnDataOptions($element)
    if page == 1
      @el.append @moreButtonContainer
      @moreButton.html(@moreButtonVal)
    else
      @getInfiniteList().append(data)
    @moreButtonContainer.remove() unless @isNeedMoreBtn(btnData)

  isNeedMoreBtn: (btnData)=>
    return false unless btnData
    btnData.totalPages > btnData.currentPage

  draw: =>
    super
    new window.MentionsHighlight(@el)

module.exports = CommentsList