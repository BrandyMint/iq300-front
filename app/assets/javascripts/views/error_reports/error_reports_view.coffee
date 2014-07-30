WidgetItemTabs = require 'views/base/widget_item_tabs'

class window.ErrorReportView extends WidgetItemTabs

  init: =>
    super
    @id = @el.data 'id'
    $(window).bind 'error_reports:opened', (event, id)=>
      @show(id)

  show: (id)=>
    @id = id
    @active = false
    @refresh()

  getUrl: =>
    "#{@url}/#{@id}" if @id

app.initializer.addComponent 'ErrorReportView', 'error-report-view-column', (item)->
  window.errorReportView = item
