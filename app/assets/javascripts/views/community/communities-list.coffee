WidgetList = require 'views/base/widget_list'

class window.CommunitiesList extends WidgetList
  init: =>
    @filters = ["folder", "providing_services", "sort", "search", "teammate"]

  isActive: =>
    false

  getParams: =>
    @params = _(@params || {}).extend {active: @activeLine}
    for filter in @filters
      @params[filter] = window.communitiesRouter.getParam filter
    @params

  getUrl: =>
    if @url.indexOf("folder=") == -1
      @url = "#{@url}?folder=#{@router().getParam('folder')}"
    @url

  bindings: =>
    super
    @communities = $ ".community-item", @el
    @communities.click @showCommunity
    activeEl = $ ".community-item.active", @el
    @activeLine = activeEl.data "id" if activeEl

  router: =>
    window.communitiesRouter

  showCommunity: (ev)=>
    target = $ ev.currentTarget
    @clearSelection()
    target.addClass "active"
    @activeLine = target.data "id"
    window.communitiesRouter.navigate "communities/#{@activeLine}", true
    window.displayMode.enableMode("view")

  clearSelection: =>
    @communities.removeClass "active"

app.initializer.addComponent "CommunitiesList", 'communities-list-column', (obj)=>
  window.communitiesList = obj
