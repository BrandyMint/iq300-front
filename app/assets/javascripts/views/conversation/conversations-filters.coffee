Widget = require 'views/base/widget'

class window.ConversationsFilter extends Widget
  bindings: =>
    @expanders = $ '.expander', @el
    @folders = $ ".folder", @el
    @expanders.click @expand
    @folders.click @filterTasks
    $(window).bind 'search-started', =>
      @folders.removeClass 'active'

  isActive: =>
    false

  expand: (e) =>
    target = $ e.currentTarget
    target.parent().toggleClass 'expanded'

  filterTasks: (e) =>
    target = $ e.currentTarget
    activeFolder = target.data "folder"
    @folders.removeClass 'active'
    target.addClass('active')
    if activeFolder
      window.conversationsRouter.setParam "folder", activeFolder
    else
      window.conversationsRouter.deleteParam "folder"
    window.conversationsList.active = false
    window.conversationsList.setDefaultPage()
    window.conversationsList.refresh()
    $('#container').removeClass('show-filters show-list show-navigation')
    false

app.initializer.addComponent "ConversationsFilter", "conversations-filter", (obj) =>
  window.conversationsFilter = obj

