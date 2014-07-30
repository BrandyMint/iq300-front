WidgetList = require 'views/base/widget_list'
ProjectDiscussionsView = require 'views/projects/discussions/project_discussion_view'

class ProjectDiscussionsList extends WidgetList
  config:
    withButton: true
    moreBtnDataClass: 'more-button-data'
    itemsOnPage: 5

  init: =>
    super
    @infiniteList = @el
    @projectDiscussions = []
    for discussion in $('.project-discussion', @el)
      @projectDiscussions.push(new ProjectDiscussionsView(discussion, @))

  addDiscussion: (response)=>
    html = $(response).hide()
    @el.prepend(html)
    html.fadeIn(1000)
    @projectDiscussions.push(new ProjectDiscussionsView($(html, @el), @))

  hideDiscussions: =>
    discussion.roll() for discussion in @projectDiscussions

  initializeData: (data)=>
    discussions = []
    for item in data
      el = $ item
      if el.hasClass 'project-discussion'
        discussions.push(new ProjectDiscussionsView(el, @))
    @projectDiscussions.concat(discussions)
    discussions

module.exports = ProjectDiscussionsList
