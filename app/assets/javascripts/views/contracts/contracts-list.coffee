WidgetList = require 'views/base/widget_list'

class window.ContractsList extends WidgetList
  init: =>
    @filters = ["folder", "sort", "search"]

  getParams: =>
    @params = _(@params || {}).extend {active: @activeLine}
    for filter in @filters
      @params[filter] = window.contractsRouter.getParam filter
    @params

  bindings: =>
    super
    @parentUrl = @el.data 'parent-url'
    @contracts = $ ".contract-item", @el
    @folders = $ "li.folder", @el

    unless @foldersBinded
      @foldersBinded = true
      @folders.click @filterByFolder
    @listHeader = $ ".header", @el
    @contracts.click @showContract
    activeEl = $ ".contract-item.active", @el
    @activeLine = activeEl.data "id" if activeEl

  router: =>
    window.contractsRouter

  showContract: (ev)=>
    # TODO
#    target = $ ev.currentTarget
#    @clearSelection()
#    target.addClass "active"
#    @activeLine = target.data "id"
#    window.contractsRouter.navigate "#{@parentUrl}/contracts/#{@activeLine}", true

  clearSelection: =>
    @contracts.removeClass "active"

  filterByFolder: (ev)=>
    target = $ ev.currentTarget
    @folders.removeClass 'active'
    target.addClass 'active'
    @router().setParam "folder", target.data 'folder'
    @setDefaultPage()
    @refresh()
    false

app.initializer.addComponent "ContractsList", 'contracts-list-column', (obj)=>
  window.contractsList = obj
