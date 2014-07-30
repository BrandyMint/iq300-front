WidgetList = require 'views/base/widget_list'

class window.ConversationsList extends WidgetList
  init: =>
    @filters = ["folder", "search"]

  isActive: =>
    false

  getParams: =>
    @params = _(@params || {}).extend {active: @activeLine}
    for filter in @filters
      @params[filter] = window.conversationsRouter.getParam filter
    @params

  updateActiveItemClass: (status)=>
    activeConversation = $ '.active', @el
    activeConversation.removeClass 'new' if activeConversation && status != 'new'

  bindings: =>
    super
    @conversations = $ ".conversation-item", @el
    @conversations.unbind "click"
    @conversations.click @showConversation
    activeEl = $ ".conversation-item.active", @el
    @activeLine = activeEl.data "id" if activeEl

  router: =>
    window.conversationsRouter
   
  showConversation: (ev)=>
    target = $ ev.currentTarget
    if target.hasClass "active"
      target.removeClass "active"
      window.displayMode.disableMode("view")
      return false
    @clearSelection()
    target.addClass "active"
    @activeLine = target.data "id"
    window.conversationsRouter.navigate "conversations/#{@activeLine}", true
    window.displayMode.enableMode("view")

  clearSelection: =>
    @conversations.removeClass 'active'

app.initializer.addComponent "ConversationsList", 'conversations-list-column', (obj)=>
  window.conversationsList = obj
