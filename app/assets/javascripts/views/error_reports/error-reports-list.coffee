WidgetList = require 'views/base/widget_list'

class window.ErrorReportsList extends WidgetList
  ACTIVE_CLASS: 'active'
  ITEM_CLASS: 'error-report-item'
  ALLOWED_FILTERS: ['type', 'sort', 'search', 'categories']

  init: =>
    super
    $(window).bind 'error_reports:filtered', (event, type)=>
      @router().setParam('type', type)
      @setDefaultPage()
      @refresh()

  bindings: =>
    super
    @error_reports = $ ".#{@ITEM_CLASS}", @el
    @error_reports.unbind 'click'
    @error_reports.click @showReport

  router: ->
    window.appRouter

  getParams: =>
    @params = @params || {}
    for filter in @ALLOWED_FILTERS
      @params[filter] = @router().getParam filter
    @params

  getParamsStr: =>
    queries = []
    params = @getParams()
    str = if _.any(params) then '?' else ''
    for key, value of params
      queries.push("#{key}=#{value}") if value != undefined and key != undefined
    str += queries.join('&')

  animatedContainer: =>
    @getInfiniteList()

  clearSelection: =>
    @activatedeReport.removeClass(@ACTIVE_CLASS) if @activatedeReport
    @activatedeReport = null

  showReport: (event)=>
    target = $(event.currentTarget)
    url = target.data('url') + @getParamsStr()
    id = target.data 'id'

    @clearSelection()
    @activatedeReport = target
    @activatedeReport.addClass @ACTIVE_CLASS

    @router().navigate(url, false)
    $(window).trigger('error_reports:opened', id)

    window.displayMode.enableMode('view', @router())

app.initializer.addComponent 'ErrorReportsList',
  className: 'error-reports-list-column'
  handler: (obj) =>
    window.errorReportsList = obj