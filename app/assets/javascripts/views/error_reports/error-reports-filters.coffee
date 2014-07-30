class window.ErrorReportsFilter
  constructor: (el)->
    @el = $ el
    @bindings()

  bindings: =>
    @expanders = $ '.expander', @el
    @folders = $ '.folder', @el
    @expanders.click @expand
    @folders.click @filterErrorReports

  expand: (e) =>
    target = $ e.currentTarget
    target.parent().toggleClass 'expanded'

  filterErrorReports: (ev) =>
    target = $ ev.currentTarget
    activeFolder = target.data 'folder'
    @folders.removeClass 'active'
    target.addClass('active')
    $(window).trigger('error_reports:filtered', activeFolder)
    $('#container').removeClass('show-filters show-list show-navigation')
    false

app.initializer.addComponent 'ErrorReportsFilter', 'error-reports-filter'