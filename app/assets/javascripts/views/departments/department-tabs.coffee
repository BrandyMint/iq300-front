WidgetItemTabs = require 'views/base/widget_item_tabs'

class window.DepartmentTabs extends WidgetItemTabs
  show: (id)=>
    @id = id
    @empty = false
    @refresh()
    @notFirstTime = true

  getUrl: =>
    regexp = /\/\d*$/
    if @url.match regexp
      @url = @url.replace regexp, "/#{@id}" if @id
    else
      @url = "#{@url}/#{@id}"
    @url

app.initializer.addComponent "DepartmentTabs"